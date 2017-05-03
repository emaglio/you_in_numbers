module User::Cell

  class ReportTemplate < Trailblazer::Cell

    def current_user
      options[:context][:current_user]
    end

    def edit
      if current_user.email == model.email
        button_to "Edit", get_report_template_user_path(model.id), class: "btn btn-outline btn-success", :method => :get
      end
    end

  end # class ReportTemplate

end # module User::Cell
