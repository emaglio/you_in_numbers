module Session::Cell
  class SignIn < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper
  end
end
