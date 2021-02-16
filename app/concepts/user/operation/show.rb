require_dependency 'session/lib/throw_exception'

class User::Operation::Show < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :show_block_user?)
  fail ::Session::Lib::ThrowException
end
