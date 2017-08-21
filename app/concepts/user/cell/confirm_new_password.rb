module User::Cell

  class ConfirmNewPassword < RequestResetPassword

    def email
      options[:email] || params[:email]
    end

    def safe_url
      options[:safe_url] || params[:safe_url]
    end

  end # class ConfirmNewPassword

end # module User::Cell
