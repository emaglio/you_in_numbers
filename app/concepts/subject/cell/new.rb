module Subject::Cell

  class New < Trailblazer::Cell
    include Formular::RailsHelper

    def current_user
      return options[:context][:current_user]
    end

    def new_report?
      params[:new_report] ||= "false"
    end

    def um_height
      current_user.content["report_settings"]["units_of_measurement"]["height"]
    end

    def um_weight
      current_user.content["report_settings"]["units_of_measurement"]["weight"]
    end
  end # class New

end # module Subject::Cell
