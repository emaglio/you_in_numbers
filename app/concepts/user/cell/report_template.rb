module User::Cell

  class ReportTemplate < Trailblazer::Cell

    def current_user
      options[:context][:current_user]
    end

    def default_obj_array
      MyDefault::ReportObj
    end

    def custom_obj_array
      current_user["content"]["report_template"]["custom"]
    end

    def label_2(obj)
      obj[:y2][:name].inspect
    end

    def label_3(obj)
      obj[:y3][:name].inspect
    end

    def icon(obj)
      icons = {
                "chart" => "fa fa-line-chart fa-4x",
                "table" => "fa fa-table fa-4x"
              }

      obj[:type] == 'report/cell/chart' ? icons["chart"] : icons["table"]
    end

    def x_label(obj)
      label = obj[:x][:name]
      label = "time" if label == "t"
      return label
    end

    def chart_title(obj)
      this_title = obj[:y1][:name]

      this_title = this_title + " - " + obj[:y2][:name] if label_2(obj) != "nil"
      this_title = this_title + " - " + obj[:y3][:name] if label_3(obj) != "nil"

      this_title = this_title + " on " + x_label(obj)

      return this_title
    end

    def title(obj)
      titles = {
                'report/cell/vo2max_summary' => "VO2max summary",
                'report/cell/training_zones' => "Training Zones"
                }

      obj[:type] == 'report/cell/chart' ? chart_title(obj) : titles[obj[:type]]
    end

    def edit
      if current_user.email == model.email
        button_to "Edit", get_report_template_user_path(model.id), class: "btn btn-outline btn-success", :method => :get
      end
    end

  end # class ReportTemplate

end # module User::Cell
