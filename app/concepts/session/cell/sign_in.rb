module Session::Cell
  class SignIn < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper

  end
end