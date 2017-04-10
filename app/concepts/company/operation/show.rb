class Company::Show < Trailblazer::Operation
  step Model(Company, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
end # class Company::Show
