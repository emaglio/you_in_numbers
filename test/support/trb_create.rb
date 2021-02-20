# frozen_string_literal: true

module Support
  class TrbCreate
    include Trailblazer::Test::Operation::Helper

    def initialize
      @strategy = FactoryBot.strategy_by_name(:attributes_for).new
    end

    def result(evaluation)
      klass = evaluation.instance_variable_get(:@attribute_assigner).instance_variable_get(:@build_class)
      factory("#{klass}::Operation::Create".constantize, { params: @strategy.result(evaluation) })[:model]
    end
  end
end
