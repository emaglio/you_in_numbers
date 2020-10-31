module User::Cell
  class Show < New
    property :email
    property :firstname
    property :lastname

    delegate :admin?, to: :current_user

    def current_user
      options[:context][:current_user]
    end

    def current_user?
      current_user.email == model.email
    end

    def edit
      button_to "Edit", edit_user_path(model), class: "btn btn-outline btn-success", :method => :get
    end

    def delete
      button_to "Delete", user_path(model.id), method: :delete,
        data: {
          confirm: "Your account within your Company details and all your Reports are going to be deleted."\
                   " Are you sure?"
        },
        class: "btn btn-outline btn-danger"
    end

    def change_password
      button_to "Change Password", get_new_password_users_path, class: "btn btn-outline btn-warning", :method => :get
    end

    def company
      Company.find_by(user_id: model.id)
    end

    def new_company
      button_to "Update details", new_company_path, class: "btn btn-outline btn-success", :method => :get
    end

    def block?
      model.block ? label = "Un-Block" : label = "Block"
      button_to label, block_users_path(id: model.id, block: !model.block),
        method: :post,
        data: { confirm: 'Are you sure?' },
        class: "btn btn-outline btn-danger"
    end
  end
end
