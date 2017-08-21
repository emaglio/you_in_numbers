class User::ResetPassword < Trailblazer::Operation
  step Nested(Tyrant::ResetPassword::Request, input: ->(options, params:, **) do
                  {
                    "email" => params[:email],
                    "url" => "http://localhost:3000/users/confirm_password"
                  }
                end
              )
  failure :get_errors!

  def get_errors!(options, *)
    raise options["result.contract.default"].errors.messages.inspect
  end
end

