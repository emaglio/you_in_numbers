module User::Cell

  class ResetPassword < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper


  end # class ResetPassword

end # module User::Cell
