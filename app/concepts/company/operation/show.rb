class Company::Operation::Show < Trailblazer::V2_1::Operation
  step Model(Company, :find_by)
  step Policy::Pundit(::Session::Policy, :company_owner?)
  failure Session::Lib::ThrowException
end # class Company::Operation::Show
