require_dependency 'session/operation/sign_in'

class Session::GitHub < Trailblazer::Operation

  step Nested( Session::SignIn::Form )
  step Nested( Tyrant::SignUp::GitHub, input: ->(options, params:, **) do
    {
      params: params,
      "state" => "login",
      "client_id" => ENV['CLIENT_ID'],
      "client_secret" => ENV['CLIENT_SECRET']
    }
  end )
end # class Session::GitHub
