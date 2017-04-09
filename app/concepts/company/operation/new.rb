class Company::New < Trailblazer::Operation
  step Model(Company, :new)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Company::Contract::New)
end # class Company::New
