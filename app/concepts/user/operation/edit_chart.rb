class User::EditChart < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user? )
  failure ::Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::EditTemplate)
end # class User::EditChart
