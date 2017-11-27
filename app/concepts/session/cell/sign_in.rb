module Session::Cell
  class SignIn < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper

    def github_link
      "http://github.com/login/oauth/authorize?client_id=#{ENV['CLIENT_ID']}&redirect_uri=http://localhost:3000/sessions/github&state=login"
    end
  end
end
