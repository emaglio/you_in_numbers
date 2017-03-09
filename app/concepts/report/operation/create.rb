require_dependency 'report/operation/new'
require_dependency 'report/operation/get_cpet_data'
require 'roo'

class Report::Create < Trailblazer::Operation
  step Nested(Report::New)
  step Contract::Validate()
  step Contract::Persist()
  step Nested(Report::GetCpetData)
  # step Nested(Report::GetCpetResults)
  # step Nested(Report::GetRmrData)
  # step Nested(Report::GetCpetResults)
  step :model!

  def model!(options, model:, cpet_params:, **)
    model[:cpet_params] = cpet_params
    model.save
  end

  
end