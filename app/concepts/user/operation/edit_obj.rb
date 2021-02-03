class User::Operation::EditObj < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::EditTemplate)
  step Contract::Validate()
  step :update_custom_template!
  step Contract::Persist()

  # rubocop:disable Metrics/AbcSize
  def update_custom_template!(options, model:, params:, **)
    obj_array = model.content['report_template']['custom']

    if (params['move_up'] != nil) && (params['move_up'].to_i > 0)
      index = params['move_up'].to_i
      obj_array[index - 1][:index] = index
      obj_array[index][:index] = index - 1
      obj_array.insert(index - 1, obj_array.delete_at(index))
    end

    if (params['move_down'] != nil) && (params['move_down'].to_i < (obj_array.size - 1))
      index = params['move_down'].to_i
      obj_array[index][:index] = index + 1
      obj_array[index + 1][:index] = index
      obj_array.insert(index + 1, obj_array.delete_at(index))
    end

    if params['edit_chart'] != nil
      index = params['edit_chart'].to_i
      obj_array[index][:y1][:name] = (params['y1_select'] != 'none') ? params['y1_select'] : nil
      obj_array[index][:y1][:colour] = (params['y1_select'] != 'none') ? params['y1_colour'] : nil
      obj_array[index][:y1][:show_scale] = (params['y1_select'] != 'none') ? (params['y1_scale'] == 'on') : false

      obj_array[index][:y2][:name] = (params['y2_select'] != 'none') ? params['y2_select'] : nil
      obj_array[index][:y2][:colour] = (params['y2_select'] != 'none') ? params['y2_colour'] : nil
      obj_array[index][:y2][:show_scale] = (params['y2_select'] != 'none') ? (params['y2_scale'] == 'on') : false

      obj_array[index][:y3][:name] = (params['y3_select'] != 'none') ? params['y3_select'] : nil
      obj_array[index][:y3][:colour] = (params['y3_select'] != 'none') ? params['y3_colour'] : nil
      obj_array[index][:y3][:show_scale] = (params['y3_select'] != 'none') ? (params['y3_scale'] == 'on') : false

      obj_array[index][:x][:name] = (params['x'] != 'none') ? params['x'] : nil
      obj_array[index][:x][:time] = (params['x'] != 'none') ? (params['x_time'] == 'on') : nil
      obj_array[index][:x][:time_format] = (params['x'] != 'none') ? params['x_format'] : nil

      obj_array[index][:show_vo2max][:show] = (params['vo2max_check'] == 'on')
      obj_array[index][:show_vo2max][:colour] = params['vo2max_colour']

      obj_array[index][:show_exer][:show] = (params['exer_check'] == 'on')
      obj_array[index][:show_exer][:colour] = params['exer_colour']

      obj_array[index][:show_AT][:show] = (params['at_check'] == 'on')
      obj_array[index][:show_AT][:colour] = params['at_colour']

      obj_array[index][:only_exer] = params['only_exer']
    end

    if params['type'] != nil
      index = params['index'].to_i

      types = {
        'Chart' => MyDefault::ReportObj[0],
        'VO2max summary' => MyDefault::ReportObj[2],
        'Training Zones' => MyDefault::ReportObj[3]
      }

      obj = types[params['type']]
      obj_array.insert(index, obj)

      # update index
      ((index + 1)..(obj_array.size - 1)).each do |i|
        obj_array[i][:index] += 1
      end

      obj_array[index][:index] = index
    end

    if params['delete'] != nil
      index = params['delete'].to_i

      obj_array.delete_at(index)

      # update index
      ((index)..(obj_array.size - 1)).each do |i|
        obj_array[i][:index] -= 1
      end
    end

    options['contract.default'].content.report_template.custom = obj_array
    options['contract.default'].content.report_template.default = model.content['report_template']['default']
  end
  # rubocop:enable Metrics/AbcSize
end # class User::Operation::EditObj
