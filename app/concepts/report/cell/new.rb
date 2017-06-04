module Report::Cell
  class New < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include Formular::RailsHelper
    include Formular::Helper

    def current_user
      return options[:context][:current_user]
    end

    def subject
      params["subject_id"] ? Subject.find_by(id: params["subject_id"]) : "nil"
    end

    def subject_id
      subject != "nil" ? subject.id : "nil"
    end

    def um_height
      current_user.content["report_settings"]["units_of_measurement"]["height"]
    end

    def um_weight
      current_user.content["report_settings"]["units_of_measurement"]["weight"]
    end

  end
end
