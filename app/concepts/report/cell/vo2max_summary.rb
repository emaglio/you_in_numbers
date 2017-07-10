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

    def params_list
      array = ""
      index = 0
      "t,VO2,VO2/Kg,HR,Power,Revolution".split(",").each do |param|
        temp = []
        temp << index
        temp << param + " unm"
        temp << value_at_AT(param)
        temp << value_at_MAX(param)
        temp << pred(param)
        temp << result_on_pred(param)
        (index >= 1) ? array += "," : array
        array +=  temp.to_json
        index += 1
      end

      return array
    end

    def value_at_AT(param)
      (model["cpet_params"].include? param) ? model["cpet_params"][param][index_AT] : model["cpet_results"][param][index_AT]
    end

    def value_at_MAX(param)
      (model["cpet_params"].include? param) ? model["cpet_params"][param][index_MAX] : model["cpet_results"][param][index_MAX]
    end

    def pred(param)
      preds = {
        "vo2" => "< " + vo2_pred.to_s,
        "vo2/kg" => "< " + vo2_kg_pred.to_s,
        "hr" => hr_pred.to_s,
      }
      return preds.fetch(param.downcase, "-")
    end

    def result_on_pred(param)
      result_on_preds = {
        "vo2" => vo2_category.to_s,
        "vo2/kg" => vo2_category.to_s,
        "hr" => hr_pred_perc.to_s,
        "anything" => "-"
      }
      return result_on_preds.fetch(param.downcase, "-")
    end

    def subject
      ::Subject.find_by(id: model.subject_id)
    end

    def hr_pred
      age = (((DateTime.now.to_i - subject.dob.to_i)/(365*24*60*60)).round)
      return (220-age)
    end

    def hr_pred_perc
      ((value_at_MAX("HR").to_f/hr_pred.to_f)*100).round
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
