module RailsBootstrap::Cell

  class TopNavigation < Trailblazer::Cell

    def current_user
      options[:context][:current_user]
    end

  end # class TopNavigation

end # module RailsBootstrao
