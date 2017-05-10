class User::EditObj < Trailblazer::Operation
  step Model(User, :find_by)
  step ->(options, model:, **) { options["default"] = model.content["report_template"]["not_custom"] }
  step Policy::Pundit( ::Session::Policy, :current_user? )
  failure ::Session::Lib::ThrowException
  step Contract::Build(constant: User::Contract::EditTemplate)
  step Contract::Validate()
  step :update_custom_template!
  step Contract::Persist()
  step :save_default!

  def update_custom_template!(options, model:, params:, **)
    obj_array = model["content"]["report_template"]["custom"]

    if params["move_up"] != nil and params["move_up"].to_i > 0
      index = params["move_up"].to_i
      obj_array[index-1][:index] = index
      obj_array[index][:index] = index -1
      obj_array.insert(index-1, obj_array.delete_at(index))
    end

    if params["move_down"] != nil and params["move_down"].to_i < (obj_array.size-1)
      index = params["move_down"].to_i
      obj_array[index][:index] = index +1
      obj_array[index+1][:index] = index
      obj_array.insert(index+1, obj_array.delete_at(index))
    end

    if params["edit_chart"] != nil
      index = params["edit_chart"].to_i
      obj_array[index][:y1][:name] = (params["y1_select"] != "none") ? params["y1_select"] : nil
      obj_array[index][:y1][:colour] = (params["y1_select"] != "none") ? params["y1_colour"] : nil
      obj_array[index][:y1][:show_scale] = (params["y1_select"] != "none") ? (params["y1_scale"] == "on") : false

      obj_array[index][:y2][:name] = (params["y2_select"] != "none") ? params["y2_select"] : nil
      obj_array[index][:y2][:colour] = (params["y2_select"] != "none") ? params["y2_colour"] : nil
      obj_array[index][:y2][:show_scale] = (params["y2_select"] != "none") ? (params["y2_scale"] == "on") : false

      obj_array[index][:y3][:name] = (params["y3_select"] != "none") ? params["y3_select"] : nil
      obj_array[index][:y3][:colour] = (params["y3_select"] != "none") ? params["y3_colour"] : nil
      obj_array[index][:y3][:show_scale] = (params["y3_select"] != "none") ? (params["y3_scale"] == "on") : false

      obj_array[index][:x][:name] = (params["x"] != "none") ? params["x"] : nil
      obj_array[index][:x][:time] = (params["x"] != "none") ? (params["x_time"] == "on") : nil
      obj_array[index][:x][:time_format] = (params["x"] != "none") ? params["x_format"] : nil

      obj_array[index][:show_vo2max][:show] = (params["vo2max_check"] == "on")
      obj_array[index][:show_vo2max][:colour] = params["vo2max_colour"]

      obj_array[index][:show_exer][:show] = (params["exer_check"] == "on")
      obj_array[index][:show_exer][:colour] = params["exer_colour"]

      obj_array[index][:show_AT][:show] = (params["at_check"] == "on")
      obj_array[index][:show_AT][:colour] = params["at_colour"]
    end

    if params["type"] != nil
      index = params["index"].to_i

      types = {
        "VO2max summary" => obj_vo2_max_summary,
        "Training Zones" => obj_training_zones,
        "Chart" => obj_chart
        }

      obj = types[params["type"]]
      obj[:index] = index
      obj_array.insert(index, obj)

      # update index
      for i in (index+1)..(obj_array.size-1)
        obj_array[i][:index] += 1
      end
    end

    if params["delete"] != nil
      index = params["delete"].to_i

      obj_array.delete_at(index)

      # update index
      for i in (index)..(obj_array.size-1)
        obj_array[i][:index] -= 1
      end
    end

    options["contract.default"].content.report_template.custom = obj_array
  end

  def save_default!(options, model:, default:, **)
    model["content"]["report_template"]["not_custom"] = []
    model["content"]["report_template"]["not_custom"] = default
    # model["content"]["report_template"]["not_custom"] << obj_chart
    # model["content"]["report_template"]["not_custom"] << obj_chart2
    # model["content"]["report_template"]["not_custom"] << obj_vo2_max_summary
    # model["content"]["report_template"]["not_custom"] << obj_training_zones
    model.save
  end

private

  def obj_chart
    chart = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "VO2", :colour => "#FF2D2D", :show_scale => true},
                          y2: {:name => "VCO2", :colour => "#2D2DFF", :show_scale => false},
                          y3: {:name => nil, :colour => nil, :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 0,
                          show_vo2max: {show: true, colour: "#000000"},
                          show_exer: {show: true, colour: "#F8CA66"},
                          show_AT: {show: true, colour: "#FF2D2D"})

    return chart
  end

  def obj_chart2
    chart2 = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "HR", :colour => "#FF2D2D", :show_scale => true},
                          y2: {:name => "Power", :colour => "#2D2DFF", :show_scale => true},
                          y3: {:name => "VE", :colour => "#ED7C52", :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 1,
                          show_vo2max: {show: false, colour: "#000000"},
                          show_exer: {show: true, colour: "#F8CA66"},
                          show_AT: {show: true, colour: "#FF2D2D"})

    return chart2
  end

  def obj_vo2_max_summary
    summary = OpenStruct.new(type: 'report/cell/vo2max_summary',
                            y1: nil,
                            y2: nil,
                            y3: nil,
                            x: nil,
                            index: 0,
                            show_vo2max: false,
                            show_exer: false,
                            show_AT: false)

    return summary
  end

  def obj_training_zones
    training_zones = OpenStruct.new(type: 'report/cell/training_zones',
                          y1: nil,
                          y2: nil,
                          y3: nil,
                          x: nil,
                          index: 0,
                          show_vo2max: false,
                          show_exer: false,
                          show_AT: false)

    return training_zones
  end

end # class User::EditObj
