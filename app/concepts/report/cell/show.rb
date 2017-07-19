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

    def tables_array
      final_array = []

      obj_array.each do |obj|
        if obj[:type] == 'report/cell/summary_table'
          temp = []
          obj = Report::Cell::SummaryTable.new(model, obj: obj).data
          obj = obj.tr('[','').tr(']','')
          temp = obj.split(",").map{ |i| JSON.parse(i)}.each_slice(6).to_a
          final_array << temp
        elsif obj[:type] == 'report/cell/training_zones'
          temp = []
          obj = Report::Cell::TrainingZones.new(model, obj: obj, context: {current_user: current_user}).data
          obj = obj.tr('[','').tr(']','').tr('\n', '')
          temp = obj.split(",").map{ |i| JSON.parse(i)}.each_slice(3).to_a
          final_array << temp
        end
      end

      return final_array
    end


  end #class Show
end
