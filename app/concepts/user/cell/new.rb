module User::Cell
  class New < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Context
    include ActionView::Helpers::CsrfHelper
    include ActionView::Helpers::FormOptionsHelper

    def current_user
      return options[:context][:current_user]
    end
  end
end
