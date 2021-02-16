class Subject::Operation::Update < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Subject, :find_by)
    step Policy::Pundit(::Session::Policy, :subject_owner?)
    fail Session::Lib::ThrowException
    step Contract::Build(constant: Subject::Contract::Edit)
  end # class Present

  step Subprocess(Present)
  step Contract::Validate()
  step Contract::Persist()
  step :redirect_new_report!

  # used in the controller to redirect to new_report_path
  def redirect_new_report!(options, params:, **)
    params['new_report'] == 'true' ? options['new_report'] = true : options['new_report'] = false
    true
  end
end # class Subject::Operation::Update
