require_dependency 'company/operation/new'

class Company::Create < Trailblazer::Operation
  step Nested(Company::New)
  step Contract::Validate()
  step Contract::Persist()
end # class Company::Create
