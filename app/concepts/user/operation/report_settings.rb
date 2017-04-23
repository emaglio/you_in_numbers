class User::ReportSettings < Trailblazer::Operation
  step Nested(User::GetReportSettings)
  step Contract::Validate()
  step Contract::Persist()
end # class User::ReportSettings
