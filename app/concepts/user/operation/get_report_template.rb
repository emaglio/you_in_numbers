class User::Operation::GetReportTemplate < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException
end # class GetReportSettings
