module User::Cell

  class EditChart < New

    def params_list
      array = []
      params_list = model.content["report_settings"]["params_list"]
      ergo_params_list = model.content["report_settings"]["ergo_params_list"]

      array << "none"

      params_list.each do |value|
        array << value
      end

      ergo_params_list.each do |value|
        array << value
      end

      return array
    end

    def index
      params["edit_chart"].to_i
    end

    def obj
      model.content["report_template"]["custom"][index]
    end

    def cancel
      button_to "Cancel", get_report_template_user_path(model.id), method: :get
    end

  end #class Chart

end # module User::Cell
