module Report::Cell

  class Chart < Trailblazer::Cell

    def current_user
      options[:context][:current_user]
    end

    def edit?
      options[:type] == "edit"
    end

    def obj
      options[:obj]
    end

    def size
      options[:size]
    end

    def index
      options[:obj][:index]
    end

    def show_vo2max
      obj[:show_vo2max][:show] == "1"
    end

    def show_exer
      obj[:show_exer][:show] == "1"
    end

    def show_AT
      obj[:show_AT][:show] == "1"
    end

    def at_colour
      show_AT ? obj[:show_AT][:colour].inspect : '#0000'.inspect
    end

    def label_1
      obj[:y1][:name] ? obj[:y1][:name].inspect : "null"
    end

    def label_2
      obj[:y2][:name] ? obj[:y2][:name].inspect : "null"
    end

    def label_3
      obj[:y3][:name] ? obj[:y3][:name].inspect : "null"
    end

    def colour_1
      obj[:y1][:colour] ? obj[:y1][:colour].inspect : "null"
    end

    def colour_2
      obj[:y2][:colour] ? obj[:y2][:colour].inspect : "null"
    end

    def colour_3
      obj[:y3][:colour] ? obj[:y3][:colour].inspect : "null"
    end

    def colour_vo2max
      obj[:show_vo2max][:colour].inspect
    end

    def colour_exer
      obj[:show_exer][:colour].inspect
    end

    def colour_at
      obj[:show_AT][:colour].inspect
    end

    def time_format
      obj[:x][:time_format] ? obj[:x][:time_format].inspect : "mm:ss".inspect
    end

    def generate_param_1
      label_1 != "nil"
    end

    def generate_param_2
      label_2 != "nil"
    end

    def generate_param_3
      label_3 != "nil"
    end

    def show_scale_1
      obj[:y1][:show_scale] == "1"
    end

    def show_scale_2
      obj[:y2][:show_scale] == "1"
    end

    def show_scale_3
      obj[:y3][:show_scale] == "1"
    end

    def x_label
      label = obj[:x][:name]
      label = "time" if label == "t"
      return label
    end

    def title
      obj[:title].inspect
    end

    def chart_id
      "canvas_#{obj[:index]}"
    end

    def y1
      (obj[:only_exer] == "1" and label_1 != "null") ? model["cpet_params"][obj[:y1][:name]][exer_phase_starts, exer_num_steps].inspect : model["cpet_params"][obj[:y1][:name]].inspect
    end

    def y2
      (obj[:only_exer] == "1" and label_2 != "null") ? model["cpet_params"][obj[:y2][:name]][exer_phase_starts, exer_num_steps].inspect : model["cpet_params"][obj[:y2][:name]].inspect
    end

    def y3
      (obj[:only_exer] == "1" and label_3 != "null") ? model["cpet_params"][obj[:y3][:name]][exer_phase_starts, exer_num_steps].inspect : "null"
    end

    def x
      obj[:only_exer] == "1" ? model["cpet_params"][obj[:x][:name]][exer_phase_starts, exer_num_steps].inspect : model["cpet_params"][obj[:x][:name]].inspect
    end

    def x_time?
      obj[:x][:time]
    end

    def x_type
      x_time? ? "time".inspect : "linear".inspect
    end

    def at_index
      model["cpet_results"]["at_index"] + model["cpet_results"]["exer_phase"]["starts"]
    end

    def at_value
      model["cpet_params"]["t"][at_index].inspect
    end

    def exer_phase_starts
      model["cpet_results"]["exer_phase"]["starts"]
    end

    def exer_num_steps
      model["cpet_results"]["exer_phase"]["num_steps"]
    end

    def exer_phase_ends
      exer_phase_starts + exer_num_steps
    end

    def exer_phase
      exer_phase_array = []
      exer_phase_array[0] = model["cpet_params"]["t"][exer_phase_starts].inspect
      exer_phase_array[1] = model["cpet_params"]["t"][exer_phase_ends].inspect

      return exer_phase_array
    end

    # TODO: make this better (maybe get this value from the Chart with js)
    def y_exer_phase #for exersice phase
      array = []
      array[0] = model["cpet_params"][obj[:y1][:name]].max
      array[1] = model["cpet_params"][obj[:y2][:name]].max unless label_2 == "null"
      array[2] = model["cpet_params"][obj[:y3][:name]].max unless label_3 == "null"
      array.max > 1000 ? (array.max+200).round(-2) : (array.max+10).round(-1)
    end

    def vo2_max_value
      model["cpet_results"]["vo2_max"]["value"]
    end

    def vo2_max_starts
      index = model["cpet_results"]["vo2_max"]["starts"] + model["cpet_results"]["exer_phase"]["starts"]
      return model["cpet_params"]["t"][index].inspect
    end

    def vo2_max_ends
      index = model["cpet_results"]["vo2_max"]["ends"] + model["cpet_results"]["exer_phase"]["starts"]
      return model["cpet_params"]["t"][index].inspect
    end
  end #class Chart

end # module Report::Cell
