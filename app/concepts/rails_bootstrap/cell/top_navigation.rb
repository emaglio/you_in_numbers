module RailsBootstrap::Cell
  class TopNavigation < Trailblazer::Cell
    delegate :admin?, to: :current_user

    def current_user
      options[:context][:current_user]
    end

    def name
      current_user.firstname ? current_user.firstname : current_user.email
    end

    def name_link
      link_to "Hi, " + name, user_path(current_user.id)
    end
  end
end
