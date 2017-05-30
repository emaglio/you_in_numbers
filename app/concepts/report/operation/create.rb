require_dependency 'report/operation/new'
require_dependency 'report/operation/get_cpet_data'
require_dependency 'report/operation/get_cpet_results'

class Report::Create < Trailblazer::Operation
  step Nested(Report::New)
  step Contract::Validate()
  step Nested(Report::GetCpetData)
  step Nested(Report::GetCpetResults, input: ->(options, cpet_params:, current_user:, **) do
                  {
                    "cpet_params" => cpet_params,
                    "current_user" => current_user
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
    options["contract.default"].content.template = params[:template]
    options["contract.default"].content.subject.height = subject.height
    options["contract.default"].content.subject.weight = subject.weight
  end

  def cpet_data!(options, params:, model:, cpet_params:, cpet_results:, **)
    options["contract.default"].cpet_params = cpet_params
    options["contract.default"].cpet_results = cpet_results
  end

end
