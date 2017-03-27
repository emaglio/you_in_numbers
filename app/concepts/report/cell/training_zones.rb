module Report::Cell

  class TrainingZones < Trailblazer::Cell

    def first_row_1
      "Fat Burning (35-50% of VO2Max)"
    end

    def first_row_2
      "Endurance (51-75% of VO2Max)"
    end

    def second_row_1
      "Anaerobic Threshold (76-90% of VO2Max)"
    end

    def second_row_2
      "VO2max (91-100% of VO2Max)"
    end
    
    def hr
      hr = []
      hr_temp = []

      hr_array = model["cpet_params"]["HR"][model["cpet_results"]["exer_phase"]["starts"], model["cpet_results"]["exer_phase"]["num_steps"]]

      model["cpet_results"]["training_zones"].each do |key, index|
        hr_temp << hr_array[index] 
      end

      i = 0
      (1..4).each do
        hr << "HR (Bpm) " + hr_temp[i].to_s + " - " + hr_temp[i+1].to_s
        i += 2
      end
      return hr
    end

    # TODO: check if it's a bike (Power and Revolution) or a treadmill (Speed and Grade)
    def load1
      load1 = []
      load1_temp = []

      load1_array = model["cpet_params"]["Power"][model["cpet_results"]["exer_phase"]["starts"], model["cpet_results"]["exer_phase"]["num_steps"]]

      model["cpet_results"]["training_zones"].each do |key, index|
        load1_temp << load1_array[index] 
      end

      i = 0
      (1..4).each do
        load1 << "Power (Watts) " + load1_temp[i].to_s + " - " + load1_temp[i+1].to_s
        i += 2
      end
      return load1
    end

    def load2
      load2 = []
      load2_temp = []

      load2_array = model["cpet_params"]["Revolution"][model["cpet_results"]["exer_phase"]["starts"], model["cpet_results"]["exer_phase"]["num_steps"]]

      model["cpet_results"]["training_zones"].each do |key, index|
        load2_temp << load2_array[index] 
      end

      i = 0
      (1..4).each do
        load2 << "RPM " + load2_temp[i].to_s + " - " + load2_temp[i+1].to_s
        i += 2
      end
      return load2
    end

  end

end