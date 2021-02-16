require 'reform/form/dry'

class User::Operation::ChangePassword < Tyrant::ChangePassword
  fail :raise_error!
  # TODO: notify user

  def raise_error!(options, *)
    raise ApplicationController::NotAuthorizedError if options['result.policy.default'].failure?
  end
end
