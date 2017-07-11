module User::Cell

  class EditChart < Trailblazer::Cell
    include Formular::RailsHelper

    def current_user
      return options[:context][:current_user]
    end

    def params_list
      array = []
      params_list = current_user.content["report_settings"]["params_list"]
      ergo_params_list = current_user.content["report_settings"]["ergo_params_list"]

      array << ["none"]

      params_list.each do |value|
        array << [value]
      end

      ergo_params_list.each do |value|
        array << [value]
      end

      return array
    end

    def index
      params["edit_chart"].to_i
    end

    def obj
      current_user.content["report_template"]["custom"][index]
    end

    def cancel
      button_to "Back", get_report_template_user_path(model.id), method: :get
    end

  end #class Chart

end # module User::Cell
