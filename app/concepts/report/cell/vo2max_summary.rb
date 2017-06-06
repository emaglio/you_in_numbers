require 'date'

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

    def subject
      ::Subject.find_by(id: model.subject_id)
    end

    def hr_pred
      age = (((DateTime.now.to_i - subject.dob.to_i)/(365*24*60*60)).round)
      return (220-age)
    end

    def hr_pred_perc
      ((hr_at_MAX.to_f/hr_pred.to_f)*100).round
    end

    def age_index
        age = (((DateTime.now.to_i - subject.dob.to_i)/(365*24*60*60)).round)

        age_array = MyDefault::SubjectAges.clone

        return age_array.find_index(age_array.min_by { |x| (x.to_f - age).abs})
    end

    def pred_array
      (subject.gender == "Male") ? array = MyDefault::ACSM_male[age_index].clone : array = MyDefault::ACSM_female[age_index].clone
      return array.reverse
    end

    def score_array
      MyDefault::SubjectScores.clone.reverse
    end

    def vo2_category
      vo2_index = pred_array.find_index{ |x| ( x > 35)}

      return score_array[vo2_index]
    end

    def vo2_kg_pred
      pred_array[pred_array.find_index{ |x| ( x > 35)}]
    end

    def vo2_pred
      (vo2_kg_pred.to_f * subject.weight.to_f).round
    end


  end # class VO2maxSummary

end # module Report::Cell
