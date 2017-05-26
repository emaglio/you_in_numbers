require_dependency 'subject/operation/new'

class Subject::Create < Trailblazer::Operation
  step Nested(Subject::New)
  step Contract::Validate()
  step Contract::Persist()
  step :redirect_new_report!

  def redirect_new_report!(options, params:, **)
    params["new_report"] == "true" ? (options["new_report"] = true) : (options["new_report"] = false)
    return true
  end
end # class Subject::Create
