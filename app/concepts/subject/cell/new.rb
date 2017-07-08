module Subject::Cell

  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper
    include ActionView::Helpers::CsrfHelper

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
