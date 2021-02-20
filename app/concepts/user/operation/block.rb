require_dependency 'session/lib/throw_exception'

class User::Operation::Block < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :admin?)
  fail Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::Block)
  step Contract::Validate()
  step Contract::Persist()
end
