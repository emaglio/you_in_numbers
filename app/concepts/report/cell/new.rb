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
      Subject.find_by(id: params["subject_id"]) if params["subject_id"]
    end

    def subject_id
      subject ? subject.id : 0
    end
  end
end
