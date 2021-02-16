require_dependency 'session/lib/throw_exception'

class User::Operation::Block < Trailblazer::V2_1::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :admin?)
  fail Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::Block)
  step Contract::Validate()
  step :model!
  # step :notify!

  def model!(_options, params:, model:, **)
    model[:block] = params['block']
    model.save
  end

  # def notify!(options, model:, **)
  #   Notification::User.({}, "email" => model.email, "type" => "block")
  # end
end
