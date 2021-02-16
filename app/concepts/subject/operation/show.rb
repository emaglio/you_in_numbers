require_dependency 'session/lib/throw_exception'

class Subject::Operation::Show < Trailblazer::V2_1::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit(::Session::Policy, :subject_owner?)
  fail ::Session::Lib::ThrowException
end
