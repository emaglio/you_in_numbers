class Subject::Update < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Subject, :find_by)
    step Policy::Pundit(::Session::Policy, :subject_owner?)
    failure Session::Lib::ThrowException
    step Contract::Build(constant: Subject::Contract::Edit)
  end # class Present

  step Nested(Present)
  step Contract::Validate()
  step Contract::Persist()
  step :redirect_new_report!

  # used in the controller to redirect to new_report_path
  def redirect_new_report!(options, params:, **)
    params['new_report'] == 'true' ? options['new_report'] = true : options['new_report'] = false
    true
  end
end # class Subject::Update
