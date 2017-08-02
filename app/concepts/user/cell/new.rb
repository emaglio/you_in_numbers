module User::Cell
  class New < Trailblazer::Cell
    include Formular::RailsHelper

    def current_user
      return options[:context][:current_user]
    end
  end
end
