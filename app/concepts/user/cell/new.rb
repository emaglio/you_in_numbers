module User::Cell
  class New < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper


    def current_user
      return options[:context][:current_user]
    end
  end
end
