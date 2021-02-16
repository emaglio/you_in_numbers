class User::Operation::GetReportSettings < Trailblazer::V2_1::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)
  fail ::Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::ReportSettings)
end # class GetReportSettings
