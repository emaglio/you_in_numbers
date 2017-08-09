class Report::Show < Trailblazer::Operation
  step Model(Report, :find_by)
  failure :not_found!, fail_fast: true
  step Policy::Pundit( ::Session::Policy, :report_owner?)
  failure Session::Lib::ThrowException

  def not_found!(options, *)
    options["not_found"] = true
  end
end
