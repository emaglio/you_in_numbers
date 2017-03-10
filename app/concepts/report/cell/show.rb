module Report::Cell

  class Show < Trailblazer::Cell 

    def vo2
      model["cpet_params"]["VO2"].inspect
    end

    def vco2
      model["cpet_params"]["VCO2"].inspect
    end

    def time
      model["cpet_params"]["t"].inspect
    end

    def at
      at_index = model["cpet_results"]["at_index"] + model["cpet_results"]["exer_phase"]["starts"]
      return at_index
    end

    def exer_phase
      exer_phase_array = []
      exer_phase_array[0] = model["cpet_results"]["exer_phase"]["starts"]
      exer_phase_array[1] = model["cpet_results"]["exer_phase"]["starts"] + model["cpet_results"]["exer_phase"]["num_steps"]

      return exer_phase_array
    end

    
  end

end