class Report::Show < Trailblazer::Operation
  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
end
