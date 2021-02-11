# trailblazer-future has a bug so I need to import this directly
module TrbV21
  extend ActiveSupport::Concern

  class Rails::Form < SimpleDelegator
    def initialize(delegated, model_class)
      super(delegated)
      @model_class = model_class
    end

    def self.name
      # for whatever reason, validations climb up the inheritance tree and require _every_ class to have a name (4.1).
      "Reform::Form"
    end

    def model_name
      ::ActiveModel::Name.new(self, nil, @model_class.to_s.camelize)
    end

    def to_model
      self
    end
  end

  def run_v21(operation, *dependencies)
    result = if Rails.application.config.trailblazer.enable_tracing
               _run_operation_v21(operation, :trace, *dependencies).tap { |r| _operation_trace(r) }
             else
               _run_operation_v21(operation, :call, *dependencies)
             end

    _assign_trb_ivars(result)

    yield(result) if result.success? && block_given?

    @_result = result
  end

  # alias run run_v21 unless method_defined?(:run)

  private

  # Override to tweak params. Not recommended.
  # Use a deserializer instead.
  def _run_params(run_params)
    run_params
  end

  # This is where we can inject Dry.RB containers and the like via dependencies.
  def _run_runtime_options(ctx = {}, *dependencies)
    [_run_options(ctx), *dependencies]
  end

  # Override this to inject dependencies such as "current_user"
  # into the runtime options.
  # def _run_options(ctx)
  #   ctx
  # end

  def _run_operation_v21(operation, call_method, *dependencies)
    operation.send(
      call_method,
      {params: _run_params(params.dup)}.merge(*_run_runtime_options(*dependencies))
    )
  end

  def _operation_trace(result)
    puts result.wtf?
  end

  def _assign_trb_ivars(result)
    @model = result[:model]
    @form  = _wrap_with_trb_form(result["contract.default"], @model.class)
  end

  def _wrap_with_trb_form(form, model)
    Rails::Form.new(form, model)
  end

  module Result
    def result
      @_result
    end
  end

  include Result
end
