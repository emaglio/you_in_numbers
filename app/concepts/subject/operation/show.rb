require_dependency 'session/lib/throw_exception'

class Subject::Show < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit( ::Session::Policy, :subject_owner?)
  failure ::Session::Lib::ThrowException
end
