require_dependency 'report/operation/new'
require_dependency 'report/operation/get_cpet_data'
require_dependency 'report/operation/get_cpet_results'

class Report::Create < Trailblazer::Operation
  step Nested(Report::New)
  step Contract::Validate()
  step Contract::Persist()
  step Nested(Report::GetCpetData)
  step Nested(Report::GetCpetResults, input: ->(options, cpet_params:, **) do
                options["cpet_params"] = cpet_params
              end)

  # step Nested(Report::GetRmrData)
  # step Nested(Report::GetCpetResults)
  step :model!

  def model!(options, model:, cpet_params:, cpet_results:, **)
    model[:cpet_params] = cpet_params
    model[:cpet_results] = cpet_results

    model.save
  end

  
end