module User::Cell

  class Settings < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def update_settings
      if current_user.email == model.email
        button_to "Upload Report Settings", get_report_settings_user_path(model.id), class: "btn btn-outline btn-success", :method => :post
      end
    end

    def update_template
      if current_user.email == model.email
        button_to "Upload Report Template", report_template_user_path(model.id), class: "btn btn-outline btn-success", :method => :get
      end
    end

    def report_settings?
      model.content["report_settings"] == nil
    end

    def report_template?
      model.content["report_template"] == nil
    end

  end # class ShowReportSettings


end # module User::Cell
