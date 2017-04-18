module Report::Cell

  class Show < Trailblazer::Cell

  end

  class Chart < Trailblazer::Cell

    def title
      "'VO2 and VCO2 on time'"
    end

    def vo2
      model["cpet_params"]["VO2"].inspect
    end

    def vco2
      model["cpet_params"]["VCO2"].inspect
    end

    def time
      model["cpet_params"]["t"].inspect
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
      array[0] = model["cpet_params"]["VO2"].max
      array[1] = model["cpet_params"]["VCO2"].max
      return (array.max + 200).round(-2)
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
  end

end
