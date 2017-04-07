module User::Cell

  class ResetPassword < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper
    include ActionView::Helpers::CsrfHelper

  end # class ResetPassword

end # module User::Cell
