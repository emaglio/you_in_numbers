module User::Cell

  class ReportSettings < New

    def edit
      if current_user.email == model.email
        button_to "Edit", get_report_settings_user_path(model.id, training_zones: model.content["training_zones_settings"]), class: "btn btn-outline btn-success", :method => :get
      end
    end

    def delete
      if current_user.email == model.email
        button_to "Delete", delete_report_settings_user_path(model.id), class: "btn btn-outline btn-danger", :method => :post
      end
    end

  end # class ReportSettings

end # module User::Cell