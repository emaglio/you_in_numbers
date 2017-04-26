module Report::Cell

  class Chart < Trailblazer::Cell

    def title
      "'#{options[:obj][:y1]} and #{options[:obj][:y2]} on time'"
    end

    def chart_id
      "canvas-#{options[:obj][:index]}"
    end

    def label_1
      options[:obj][:y1].inspect
    end

    def label_2
      options[:obj][:y2].inspect
    end

    def y1
      model["cpet_params"][options[:obj][:y1]].inspect
    end

    def y2
      model["cpet_params"][options[:obj][:y2]].inspect
    end

    def x
      model["cpet_params"][options[:obj][:x]].inspect
    end

    def x_type
      if options[:obj][:x].downcase == "t" or options[:obj][:x].downcase == "time"
        type = "time".inspect
      else
        type = "".inspect
      end
      return type
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

    def exer_phase_ends
      model["cpet_results"]["exer_phase"]["starts"] + model["cpet_results"]["exer_phase"]["num_steps"]
    end

    def exer_phase
      exer_phase_array = []
      exer_phase_array[0] = model["cpet_params"]["t"][exer_phase_starts].inspect
      exer_phase_array[1] = model["cpet_params"]["t"][exer_phase_ends].inspect

      return exer_phase_array
    end

    def y_exer_phase #for exersice phase
      array = []
      array[0] = model["cpet_params"][options[:obj][:y1]].max
      array[1] = model["cpet_params"][options[:obj][:y2]].max
      array.max > 1000 ? (array.max + 200).round(-2) : (array.max+20).round(-1)
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
