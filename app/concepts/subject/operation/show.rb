require_dependency 'session/lib/throw_exception'

class Subject::Show < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure ::Session::Lib::ThrowException
end
