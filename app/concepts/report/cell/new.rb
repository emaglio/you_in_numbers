module Report::Cell
  class New < Trailblazer::Cell
    include Formular::RailsHelper
    include ActionView::Context
    include ActionView::Helpers::FormOptionsHelper

    def current_user
      options[:context][:current_user]
    end

    def subject
      params['subject_id'] ? ::Subject.find_by(id: params['subject_id']) : 'nil'
    end

    def subject_id
      subject != 'nil' ? subject.id : 'nil'
    end

    def um_height
      current_user.content['report_settings']['units_of_measurement']['height']
    end

    def um_weight
      current_user.content['report_settings']['units_of_measurement']['weight']
    end

    def report_title
      DateTime.now.strftime('%d-%b-%Y') +
        " - #{subject.firstname} #{subject.lastname} (#{subject.dob.strftime('%d-%b-%Y')})"
    end
  end
end
