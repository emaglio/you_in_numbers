class Report::Operation::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Report, :new)
    step Policy::Pundit(::Session::Policy, :signed_in?)
    fail Session::Lib::ThrowException
    step Contract::Build(constant: Report::Contract::New)
  end # class Present

  step Subprocess(Present)
  step Contract::Validate()
  step Subprocess(GetCpetData)
  step Subprocess(GetCpetResults), input: ->(options, cpet_params:, current_user:, **) do
                                            {
                                              'cpet_params' => cpet_params,
                                              'current_user' => current_user
                                            }
                                          end

  # step Subprocess(Report::GetRmrData)
  # step Subprocess(Report::GetCpetResults)
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
