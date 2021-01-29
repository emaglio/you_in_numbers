module User::Cell
  class RequestResetPassword < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Helpers::CsrfHelper

    def url
      'http://localhost:3000/users/confirm_new_password'
    end
  end # class ResetPassword
end # module User::Cell
