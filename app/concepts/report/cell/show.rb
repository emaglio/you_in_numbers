module Report::Cell

  class Show < Trailblazer::Cell
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::FormTagHelper

    def current_user
      options[:context][:current_user]
    end

    def obj_array
      model.content["template"]=="default" ? MyDefault::ReportObj : current_user.content["report_template"]["custom"]
    end

    def js_array
      array = []
      obj_array.collect do |obj|
        obj[:type] == 'report/cell/chart' ? array << "chart" : array << "dom"
      end

      return array
    end

  end #class Show

end
