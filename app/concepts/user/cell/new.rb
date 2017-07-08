module User::Cell
  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper
    include ActionView::Helpers::CsrfHelper

    def current_user
      return options[:context][:current_user]
    end
  end
end
