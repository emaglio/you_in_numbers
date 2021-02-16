class User::Operation::UpdateChart < Trailblazer::V2_1::Operation
  class Present < Trailblazer::V2_1::Operation
    step Model(User, :find_by)
    step Policy::Pundit(::Session::Policy, :current_user?)
    fail ::Session::Lib::ThrowException
    step Contract::Build(constant: User::Contract::EditChart)
  end # class Present

  step Subprocess(Present)
  step Contract::Validate()
  step :update_chart!
  step Contract::Persist()

  def update_chart!(_options, model:, params:, **)
    obj_array = model.content['report_template']['custom']

    index = params['edit_chart'].to_i

    obj_array[index][:title] = params['title']

    obj_array[index][:y1][:name] = (params['y1_select'] != 'none') ? params['y1_select'] : nil
    obj_array[index][:y1][:colour] = params['y1_colour']
    obj_array[index][:y1][:show_scale] = params['y1_scale']

    obj_array[index][:y2][:name] = (params['y2_select'] != 'none') ? params['y2_select'] : nil
    obj_array[index][:y2][:colour] = params['y2_colour']
    obj_array[index][:y2][:show_scale] = params['y2_scale']

    obj_array[index][:y3][:name] = (params['y3_select'] != 'none') ? params['y3_select'] : nil
    obj_array[index][:y3][:colour] = params['y3_colour']
    obj_array[index][:y3][:show_scale] = params['y3_scale']

    obj_array[index][:x][:name] = (params['x'] != 'none') ? params['x'] : nil
    obj_array[index][:x][:time] = params['x_time']
    obj_array[index][:x][:time_format] = (params['x'] != 'none') ? params['x_format'] : nil

    obj_array[index][:show_vo2max][:show] = params['vo2max_show']
    obj_array[index][:show_vo2max][:colour] = params['vo2max_colour']

    obj_array[index][:show_exer][:show] = params['exer_show']
    obj_array[index][:show_exer][:colour] = params['exer_colour']

    obj_array[index][:show_AT][:show] = params['at_show']
    obj_array[index][:show_AT][:colour] = params['at_colour']

    obj_array[index][:only_exer] = params['only_exer']
    true
  end
end # class User::EditChart
