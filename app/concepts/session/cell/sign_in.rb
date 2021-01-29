require 'cell/translation'

module Session::Cell
  class SignIn < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper
    include ActionView::Helpers::TranslationHelper
    include ::Cell::Translation

    self.translation_path = 'session.sign_in'

    def title
      t('.title')
    end
  end
end
