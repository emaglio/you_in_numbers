require_dependency 'subject/operation/edit'

class Subject::Update < Trailblazer::Operation
  step Nested(Subject::Edit)
  step Contract::Validate()
  step Contract::Persist()
  step :redirect_new_report!

  #used in the controller to redirect to new_report_path
  def redirect_new_report!(options, params:, **)
    params[:new_report] ? (options["new_report"] = params[:new_report]) : true
  end
end # class Subject::Update
