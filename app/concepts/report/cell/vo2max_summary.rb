module Report::Cell

  class Vo2maxSummary < Trailblazer::Cell

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

    def index_AT
      model["cpet_results"]["exer_phase"]["starts"] + model["cpet_results"]["at_index"]
    end

    def index_MAX
      model["cpet_results"]["exer_phase"]["starts"] + model["cpet_results"]["vo2_max"]["index"]
    end

    def time_at_AT
      model["cpet_params"]["t"][index_AT]
    end

    def time_at_MAX
      model["cpet_params"]["t"][index_MAX]
    end

    def vo2_at_AT
      model["cpet_params"]["VO2"][index_AT]
    end

    def vo2_at_MAX
      model["cpet_results"]["vo2_max"]["value"]
    end

    def vo2_kg_at_AT
      model["cpet_params"]["VO2/Kg"][index_AT]
    end

    def vo2_kg_at_MAX
      model["cpet_params"]["VO2/Kg"][index_MAX]
    end

    def hr_at_AT
      model["cpet_params"]["HR"][index_AT]
    end

    def hr_at_MAX
      model["cpet_params"]["HR"][index_MAX]
    end

    # TODO: make this smart
    def load_1
      load1 = []

      load1[0] = "Power"
      load1[1] = " (Watt)"

      return load1
    end

    def load_1_at_AT
      model["cpet_params"]["Power"][index_AT]
    end

    def load_1_at_MAX
      model["cpet_params"]["Power"][index_MAX]
    end

    # TODO: make this smart
    def load_2
      load2 = []

      load2[0] = "Revolution"
      load2[1] = " (RPM)"

      return load2
    end

    def load_2_at_AT
      model["cpet_params"]["Revolution"][index_AT]
    end

    def load_2_at_MAX
      model["cpet_params"]["Revolution"][index_MAX]
    end


  end # class VO2maxSummary

end # module Report::Cell
