module Report::Cell
  class EditVO2Max < Trailblazer::Cell
    include Formular::Helper

    def obj_array
      MyDefault::EditVO2MaxObj
    end

    def current_user
      options[:context][:current_user] ||= options[:current_user]
    end

    def chart_array
      array = []
      obj_array.each_with_index do |obj, index|
        cell = cell(obj[:type], model, obj: obj, current_user: current_user)
        temp = {}

        temp['chart_id'] = cell.chart_id

        temp['time_format'] = cell.time_format
        temp['x_time?'] = cell.x_time?
        temp['x'] = cell.x
        temp['x_type'] = cell.x_type
        temp['x_label'] = cell.x_label

        temp['colour_vo2max'] = cell.colour_vo2max
        temp['vo2_max_starts'] = cell.vo2_max_starts
        temp['vo2_max_ends'] = cell.vo2_max_ends
        temp['vo2_max_value'] = cell.vo2_max_value
        temp['show_vo2max'] = cell.show_vo2max

        temp['colour_exer'] = cell.colour_exer
        temp['exer_starts'] = cell.exer_phase[0]
        temp['exer_ends'] = cell.exer_phase[1]
        temp['exer_value'] = cell.y_exer_phase
        temp['show_exer'] = cell.show_exer

        temp['at_colour'] = cell.at_colour
        temp['at_value'] = cell.at_value
        temp['show_AT'] = cell.show_AT

        temp['generate_param_1'] = cell.generate_param_1
        temp['colour_1'] = cell.colour_1
        temp['label_1'] = cell.label_1
        temp['y1'] = cell.y1
        temp['show_scale_1'] = cell.show_scale_1

        temp['generate_param_2'] = cell.generate_param_2
        temp['colour_2'] = cell.colour_2
        temp['label_2'] = cell.label_2
        temp['y2'] = cell.y2
        temp['show_scale_2'] = cell.show_scale_2

        temp['generate_param_3'] = cell.generate_param_3
        temp['colour_3'] = cell.colour_3
        temp['label_3'] = cell.label_3
        temp['y3'] = cell.y3
        temp['show_scale_3'] = cell.show_scale_3

        temp['restore_start'] = model['cpet_results']['vo2_max']['starts'] +
                                model['cpet_results']['exer_phase']['starts']
        temp['restore_end'] = model['cpet_results']['vo2_max']['ends'] +
                              model['cpet_results']['exer_phase']['starts']
        temp['min_index'] = cell.exer_phase_starts
        temp['max_index'] = cell.exer_phase_ends

        array << temp
      end

      return array
    end
  end
end
