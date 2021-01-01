module Session::Cell
  class SignIn < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper
    include Webpacker::Helper

    def github_link
      'http://github.com/login/oauth/authorize?client_id=7764859b18066947562c&redirect_uri=http://localhost:3000/sessions/github&state=login'
    end
  end
end
