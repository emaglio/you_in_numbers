class Report::Operation::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Report, :new)
    step Policy::Pundit(::Session::Policy, :signed_in?)
    failure Session::Lib::ThrowException
    step Contract::Build(constant: Report::Contract::New)
  end # class Present

  step Nested(Present)
  step Contract::Validate()
  step Nested(GetCpetData)
  step Nested(GetCpetResults, input: ->(options, cpet_params:, current_user:, **) do
                  {
                    'cpet_params' => cpet_params,
                    'current_user' => current_user
                  }
                end
              )

  # step Nested(Report::GetRmrData)
  # step Nested(Report::GetCpetResults)
  step :set_template_subject_details!
  step :cpet_data!
  # step :rmr_data!
  step Contract::Persist()

  def set_template_subject_details!(options, params:, **)
    subject = Subject.find_by(id: params[:subject_id])
    options['contract.default'].content.template = params[:template]
    options['contract.default'].content.subject.height = subject.height
    options['contract.default'].content.subject.weight = subject.weight
  end

  def cpet_data!(options, cpet_params:, cpet_results:, **)
    options['contract.default'].cpet_params = cpet_params
    options['contract.default'].cpet_results = cpet_results
  end
end
