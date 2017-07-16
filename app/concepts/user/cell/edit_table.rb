module User::Cell

  class EditTable < Trailblazer::Cell
    include Formular::RailsHelper

    def current_user
      return options[:context][:current_user]
    end

    def params_list
      array = ""
      params_list = current_user.content["report_settings"]["params_list"]
      ergo_params_list = current_user.content["report_settings"]["ergo_params_list"]

      array = params_list.join(",")
      array += "," + ergo_params_list.join(",")

      return array
    end

    def index
      params["edit_table"].to_i
    end

    def obj
      current_user.content["report_template"]["custom"][index]
    end

    def cancel
      button_to "Back", get_report_template_user_path(model.id), method: :get
    end

    def params_list_lable
      "Params List:\nsmall\n"
    end



  end #class Chart

end # module User::Cell
