class User::ResetPassword < Trailblazer::Operation
  step Nested(Tyrant::ResetPassword)
  failure :get_errors!

  def get_errors!(options, *)
    raise options['result.contract.default'].errors.messages.inspect
  end
end
