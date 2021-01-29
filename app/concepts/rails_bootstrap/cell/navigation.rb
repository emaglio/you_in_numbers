module RailsBootstrap::Cell
  class NavigationMenu < Trailblazer::Cell
    delegate :admin?, to: :current_user

    def current_user
      options[:context][:current_user]
    end

    def welcome
      current_user.firstname.blank? ? 'Hi, ' + current_user.email : 'Hi, ' + current_user.firstname
    end

    def signed_in?
      current_user != nil
    end
  end

  class Navigation < Trailblazer::Cell
    def current_user
      options[:context][:current_user]
    end
  end

  class WelcomeNavigation < Trailblazer::Cell
  end
end
