class User::Operation::GetReportTemplate < Trailblazer::V2_1::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)
  fail ::Session::Lib::ThrowException
end # class GetReportSettings
