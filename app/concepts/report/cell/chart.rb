module Report::Cell

  class Chart < Trailblazer::Cell

    def current_user
      options[:context][:current_user]
    end

    def edit?
      options[:type] == "edit"
    end

    def data
      edit? ? options[:data] : model
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
      show_AT ? obj[:show_AT][:colour] : '#0000'
    end

    def label_1
      obj[:y1][:name] ? obj[:y1][:name] : "null"
    end

    def label_2
      obj[:y2][:name] ? obj[:y2][:name] : "null"
    end

    def label_3
      obj[:y3][:name] ? obj[:y3][:name] : "null"
    end

    def colour_1
      obj[:y1][:colour] ? obj[:y1][:colour] : '#0000'
    end

    def colour_2
      obj[:y2][:colour] ? obj[:y2][:colour] : '#0000'
    end

    def colour_3
      obj[:y3][:colour] ? obj[:y3][:colour] : '#0000'
    end

    def colour_vo2max
      obj[:show_vo2max][:colour]
    end

    def colour_exer
      obj[:show_exer][:colour]
    end

    def colour_at
      obj[:show_AT][:colour]
    end

    def time_format
      obj[:x][:time_format] ? obj[:x][:time_format] : "mm:ss"
    end

    def generate_param_1
      label_1 != "null"
    end

    def generate_param_2
      label_2 != "null"
    end

    def generate_param_3
      label_3 != "null"
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
      obj[:title]
    end

    def chart_id
      "canvas_#{obj[:index]}"
    end

    def y1
      return "null" if label_1 == "null"
      (obj[:only_exer] == "1") ? data["cpet_params"][obj[:y1][:name]][exer_phase_starts, exer_num_steps] : data["cpet_params"][obj[:y1][:name]]
    end

    def y2
      return "null" if label_2 == "null"
      (obj[:only_exer] == "1") ? data["cpet_params"][obj[:y2][:name]][exer_phase_starts, exer_num_steps] : data["cpet_params"][obj[:y2][:name]]
    end

    def y3
      return "null" if label_3 == "null"
      (obj[:only_exer] == "1") ? data["cpet_params"][obj[:y3][:name]][exer_phase_starts, exer_num_steps] : data["cpet_params"][obj[:y3][:name]]
    end

    def x
      obj[:only_exer] == "1" ? data["cpet_params"][obj[:x][:name]][exer_phase_starts, exer_num_steps] : data["cpet_params"][obj[:x][:name]]
    end

    def x_time?
      obj[:x][:time] == "1"
    end

    def x_type
      x_time? ? "time" : "linear"
    end

    def at_index
      data["cpet_results"]["at_index"] + data["cpet_results"]["exer_phase"]["starts"]
    end

    def at_value
      data["cpet_params"][obj[:x][:name]][at_index]
    end

    def exer_phase_starts
      data["cpet_results"]["exer_phase"]["starts"]
    end

    def exer_num_steps
      data["cpet_results"]["exer_phase"]["num_steps"]
    end

    def exer_phase_ends
      exer_phase_starts + exer_num_steps
    end

    def exer_phase
      exer_phase_array = []
      exer_phase_array[0] = data["cpet_params"]["t"][exer_phase_starts]
      exer_phase_array[1] = data["cpet_params"]["t"][exer_phase_ends]

      return exer_phase_array
    end

    # TODO: make this better (maybe get this value from the Chart with js)
    def y_exer_phase #for exersice phase
      array = []
      array[0] = data["cpet_params"][obj[:y1][:name]].max
      array[1] = data["cpet_params"][obj[:y2][:name]].max unless label_2 == "null"
      array[2] = data["cpet_params"][obj[:y3][:name]].max unless label_3 == "null"
      array.max > 1000 ? (array.max+200).round(-2) : (array.max+10).round(-1)
    end

    def vo2_max_value
      data["cpet_results"]["vo2_max"]["value"]
    end

    def vo2_max_starts
      index = data["cpet_results"]["vo2_max"]["starts"] + data["cpet_results"]["exer_phase"]["starts"]
      return data["cpet_params"]["t"][index]
    end

    def vo2_max_ends
      index = data["cpet_results"]["vo2_max"]["ends"] + data["cpet_results"]["exer_phase"]["starts"]
      return data["cpet_params"]["t"][index]
    end

    # Edit AT
    def max_scale_value
      array = []
      array << data["cpet_params"][obj[:x][:name]][exer_phase_starts, exer_num_steps].max if !x_time?
      array << data["cpet_params"][obj[:y1][:name]][exer_phase_starts, exer_num_steps].max
      array << data["cpet_params"][obj[:y2][:name]][exer_phase_starts, exer_num_steps].max unless label_2 == "null"

      array.max > 1000 ? (array.max+200).round(-2) : (array.max+5).round(-1)
    end

    def min_scale_value
      array = []
      array << data["cpet_params"][obj[:x][:name]][exer_phase_starts, exer_num_steps].min if !x_time?
      array << data["cpet_params"][obj[:y1][:name]][exer_phase_starts, exer_num_steps].min
      array << data["cpet_params"][obj[:y2][:name]][exer_phase_starts, exer_num_steps].min unless label_2 == "null"

      (array.min-5).round(-1)
    end

  end #class Chart

end # module Report::Cell
