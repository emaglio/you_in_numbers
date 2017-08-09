module Report::Cell

  class TrainingZones < New

    def content
      current_user.content
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

    def zones_settings
      content["report_settings"]["training_zones_settings"] if content
    end

    def ergo_params
      content["report_settings"]["ergo_params_list"] if content
    end

    def first_row_1
      "Fat Burning (" + zones_settings[0].to_s + "-" + zones_settings[1].to_s + "% of VO2Max)"
    end

    def first_row_2
      "Endurance (" + zones_settings[2].to_s + "-" + zones_settings[3].to_s + "% of VO2Max)"
    end

    def second_row_1
      "Anaerobic Threshold (" + zones_settings[4].to_s + "-" + zones_settings[5].to_s + "% of VO2Max)"
    end

    def second_row_2
      "VO2max (" + zones_settings[6].to_s + "-" + zones_settings[7].to_s + "% of VO2Max)"
    end

    def hr
      hr = []
      hr_temp = []

      hr_array = data["cpet_params"]["HR"][data["cpet_results"]["exer_phase"]["starts"], data["cpet_results"]["exer_phase"]["num_steps"]]

      data["cpet_results"]["training_zones"].each do |key, index|
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

      load1_array = data["cpet_params"]["Power"][data["cpet_results"]["exer_phase"]["starts"], data["cpet_results"]["exer_phase"]["num_steps"]]

      data["cpet_results"]["training_zones"].each do |key, index|
        load1_temp << load1_array[index]
      end

      i = 0
      (1..4).each do
        load1 << "#{ergo_params[0]} (#{ergo_params[1]}) " + load1_temp[i].to_s + " - " + load1_temp[i+1].to_s
        i += 2
      end
      return load1
    end

    def load2
      load2 = []
      load2_temp = []

      load2_array = data["cpet_params"]["Revolution"][data["cpet_results"]["exer_phase"]["starts"], data["cpet_results"]["exer_phase"]["num_steps"]]

      data["cpet_results"]["training_zones"].each do |key, index|
        load2_temp << load2_array[index]
      end

      i = 0
      (1..4).each do
        load2 << "#{ergo_params[2]} (#{ergo_params[3]}) " + load2_temp[i].to_s + " - " + load2_temp[i+1].to_s
        i += 2
      end
      return load2
    end

    def table_content
      array = []
      array << [0, first_row_1, first_row_2]
      array << [1, hr[0], hr[1]]
      array << [2, load1[0], load1[1]]
      array << [3, load2[0], load2[1]]
      array << [4, first_row_2, first_row_2]
      array << [5, hr[2], hr[3]]
      array << [6, load1[2], load1[3]]
      array << [7, load2[2], load2[3]]

      result = ""

      array.each_with_index do |obj, index|
        result += obj.to_json
        result += ","
      end

      return result
    end

  end

end
