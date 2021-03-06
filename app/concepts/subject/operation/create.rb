class Subject::Operation::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Subject, :new)
    step Policy::Pundit(::Session::Policy, :signed_in?)
    fail Session::Lib::ThrowException
    step Contract::Build(constant: Subject::Contract::New)
  end # class Present

  step Subprocess(Present)
  step Contract::Validate()
  step Contract::Persist()
  step :redirect_new_report!

  def redirect_new_report!(options, params:, **)
    params['new_report'] == 'true' ? (options['new_report'] = true) : (options['new_report'] = false)
    return true
  end
end # class Subject::Operation::Create
