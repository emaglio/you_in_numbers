module User::Cell

  class ChangePassword < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper

  end # class ChangePassword

end # module User::Cell
