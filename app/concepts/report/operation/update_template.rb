class Report::UpdateTemplate < Trailblazer::Operation
  step Model(Report, :find_by)
  failure :report_not_found!, fail_fast: :true
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Report::Contract::UpdateTemplate)
  step Contract::Validate()
  step Contract::Persist()

  def report_not_found!(options, *)
    options["not_found"] = true
  end

end # class Report::UpdateTemplate
