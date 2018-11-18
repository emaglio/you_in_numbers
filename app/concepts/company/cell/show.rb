module Company::Cell

  class Show < New

    extend Paperdragon::Model::Reader
    processable_reader :logo
    property :logo_meta_data

    def edit
      if current_user.id == model.user_id
        button_to "Edit", edit_company_path(model), class: "btn btn-outline btn-success", :method => :get
      end
    end

    def delete
      if current_user.id == model.user_id
        button_to "Delete", company_path(model.id),
          method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-outline btn-danger", id: "delete_company"
      end
    end

    def delete_logo
      if current_user.id == model.user_id
        button_to "Remove Logo", delete_logo_company_path(model),
          method: :post, data: { confirm: 'Are you sure?' }, class: "btn btn-outline btn-danger"
      end
    end

    def upload_logo
      if current_user.id == model.user_id
        button_to "Upload Logo", edit_company_path(model), class: "btn btn-outline btn-success", :method => :get
      end
    end

  end # class Show

end # module Company::Cell
