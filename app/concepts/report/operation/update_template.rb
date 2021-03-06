class Report::Operation::UpdateTemplate < Trailblazer::Operation
  step Model(Report, :find_by)
  fail :report_not_found!, fail_fast: :true
  step Policy::Pundit(::Session::Policy, :report_owner?)
  fail Session::Lib::ThrowException
  step Contract::Build(constant: Report::Contract::UpdateTemplate)
  step Contract::Validate()
  step :set_template!
  step Contract::Persist()

  def report_not_found!(options, *)
    options['not_found'] = true
  end

  def set_template!(options, params:, **)
    options['contract.default'].content.template = params[:template]
  end
end # class Report::Operation::UpdateTemplate
