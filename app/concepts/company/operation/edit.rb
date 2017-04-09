class Company::Edit < Trailblazer::Operation
  step Model(Company, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Company::Contract::New)
end # class Company::Edit
