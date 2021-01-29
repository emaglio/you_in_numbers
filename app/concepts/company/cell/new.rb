module Company::Cell
  class New < Trailblazer::Cell
    include Formular::RailsHelper

    def current_user
      return options[:context][:current_user]
    end
  end # class New
end # module Company::Cell
