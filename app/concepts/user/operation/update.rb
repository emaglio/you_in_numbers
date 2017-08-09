class User::Update < Trailblazer::Operation

  class Present < Trailblazer::Operation
    step Model(User, :find_by)
    step Policy::Pundit( ::Session::Policy, :current_user? )
    failure ::Session::Lib::ThrowException
    step Contract::Build(constant: User::Contract::Update)
  end # class Present

  step Nested( Present )
  step Contract::Validate()
  step Contract::Persist()
  step :update!

  def update!(options, model:, **)
    model.save
  end
end
