class Session::Operation::SignIn < Trailblazer::Operation
  class Form < Trailblazer::Operation
    step Contract::Build(constant: Session::Contract::SignIn)
  end

  step Subprocess(Form)
  step Contract::Validate()
  step :model!

  def model!(options, params:, **)
    options['model'] = User.find_by(email: params[:email])
  end
end
