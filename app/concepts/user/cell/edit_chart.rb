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

    def show_y1_scale
      obj[:y1][:show_scale] == "1"
    end

    def show_y2_scale
      obj[:y2][:show_scale] == "1"
    end

    def show_y3_scale
      obj[:y3][:show_scale] == "1"
    end

    def x_time_scale
      obj[:x][:time] == "1"
    end

    def vo2max_show
      obj[:show_vo2max][:show] == "1"
    end

    def exer_show
      obj[:show_exer][:show] == "1"
    end

    def at_show
      obj[:show_AT][:show] == "1"
    end

    def plot_only_exer
      obj[:only_exer] == "1"
    end

  end #class Chart

end # module User::Cell
