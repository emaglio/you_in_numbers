class GetReportTemplate < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user? )
  failure ::Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::ReportTemplate)
end # class GetReportSettings
