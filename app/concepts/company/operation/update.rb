class Company::Update < Trailblazer::Operation
  step Nested(Company::Edit)
  step Contract::Validate()
  step Contract::Persist()
end # class Company::Update
