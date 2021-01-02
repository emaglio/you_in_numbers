require "cell/translation"

module Session::Cell
  class SignIn < Trailblazer::Cell
    include ActionView::Helpers::TranslationHelper
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Context
    include ::Cell::Translation

    include ::Cell::Slim

    include ActionView::Helpers::CsrfHelper

    self.translation_path = 'session.sign_in'

    def title
      t('.title')
    end
  end
end





