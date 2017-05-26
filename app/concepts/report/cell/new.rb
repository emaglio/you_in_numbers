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

  end
end
