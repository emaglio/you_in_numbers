module User::Cell

  class Show < New

    property :email
    property :firstname
    property :lastname

    def current_user
      return options[:context][:current_user]
    end

    def edit
      if current_user.email == model.email or current_user.email == "admin@email.com"
        button_to "Edit", edit_user_path(model), class: "btn btn-outline btn-success", :method => :get
      end
    end

    def delete
      if current_user.email == model.email or current_user.email == "admin@email.com"
        button_to "Delete", user_path(model.id), method: :delete, data: {confirm: 'Are you sure?'}, class: "btn btn-outline btn-danger"
      end
    end

    def change_password
      if current_user.email == model.email or current_user.email == "admin@email.com"
        button_to "Change Password", get_new_password_users_path, class: "btn btn-outline btn-warning", :method => :get
      end
    end

    def company
      Company.find_by(user_id: model.id)
    end

    def new_company
      if current_user.email == model.email or current_user.email == "admin@email.com"
        button_to "Update details", new_company_path, class: "btn btn-outline btn-success", :method => :get
      end
    end


  end
end
