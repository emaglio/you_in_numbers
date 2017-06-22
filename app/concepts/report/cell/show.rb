module Report::Cell

  class Show < Trailblazer::Cell
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::FormTagHelper

    def current_user
      options[:context][:current_user]
    end

    def obj_array
      array = []
      array << MyDefault::Subject.clone #add this to create the subject image
      current_user.content["report_template"][model.content["template"]].each do |obj|
        array << obj
      end
      return array
    end

    def js_array
      array = []
      obj_array.each do |obj|
        puts obj[:type].inspect
        obj[:type] == 'report/cell/chart' ? array << "chart" : (obj[:type] == 'report/cell/subject' ? array << "subject" : array << "dom")
      end

      return array
    end

  end #class Show

end
