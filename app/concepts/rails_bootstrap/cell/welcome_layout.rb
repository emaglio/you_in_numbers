module RailsBootstrap::Cell

  class WelcomeLayout < Trailblazer::Cell
    include ActionView::Helpers::CsrfHelper
    property :current_user
    property :real_user
    property :signed_in?

    def is_number? string
      true if Float(string) rescue false
    end

    def welcome?
      params["action"] == "welcome" and params["controller"] == "reports"
    end

    def show_id
      return params["id"]
    end
  end
end
