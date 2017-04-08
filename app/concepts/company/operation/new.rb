class Company::New < Trailblazer::Operation
  step Model(Company, :new)
  step Contract::Build(constant: Company::Contract::New)
end # class Company::New
