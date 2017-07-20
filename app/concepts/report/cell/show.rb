module Report::Cell

  class Show < Trailblazer::Cell
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::FormTagHelper

    def current_user
      options[:context][:current_user] ||= options[:current_user]
    end

    def obj_array
      array = []
      current_user.content["report_template"][model.content["template"]].each do |obj|
        array << obj
      end
      return array
    end

    def js_array
      array = []
      obj_array.each do |obj|
        obj[:type] == 'report/cell/chart' ? array << "chart" : (obj[:type] == 'report/cell/subject' ? array << "subject" : array << "dom")
      end

      return array
    end

    def tables
      result = ""
      count = 0
      obj_array.each do |obj|
        if obj[:type] == 'report/cell/summary_table'
          cell = Report::Cell::SummaryTable.new(model, obj: obj).data
          result += "//table_#{obj[:index]}//" + cell.to_s
          count += 1
        elsif obj[:type] == 'report/cell/training_zones'
          cell = Report::Cell::TrainingZones.new(model, obj: obj, context: {current_user: current_user}).data
          result += "//training_zones_#{obj[:index]}//" + cell.to_s
          count += 1
        end
      end
      result = "//#{count}//" + result
      return result
    end


  end #class Show
end
