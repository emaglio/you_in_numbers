require 'reform/form/dry'

class User::ChangePassword < Tyrant::ChangePassword
  failure :raise_error!
  # TODO: notify user

  def raise_error!(options, *)
    raise ApplicationController::NotAuthorizedError if options["result.policy.default"].failure?
  end
end
