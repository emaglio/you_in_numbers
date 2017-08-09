require 'date'

module Report::Cell

  class SummaryTable < Trailblazer::Cell

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

    def index_AT
      data["cpet_results"]["exer_phase"]["starts"] + data["cpet_results"]["at_index"]
    end

    def index_MAX
      data["cpet_results"]["exer_phase"]["starts"] + data["cpet_results"]["vo2_max"]["index"]
    end

    def table_content
      array = ""
      params_list = obj[:params_list].split(",")
      params_unm_list = obj[:params_unm_list].split(",")
      params_list.zip(params_unm_list).each_with_index do |param, index|
        temp = []
        temp << index
        param.last == "-" ? value = "#{param.first}" : value = "#{param.first} (#{param.last})"
        temp << value
        temp << value_at_AT(param.first)
        temp << value_at_MAX(param.first)
        temp << pred(param.first)
        temp << result_on_pred(param.first)
        array +=  temp.to_json
        array += ","
      end

      return array
    end

    def value_at_AT(param)
      (data["cpet_params"].include? param) ? data["cpet_params"][param][index_AT] : data["cpet_results"][param][index_AT]
    end

    def value_at_MAX(param)
      (data["cpet_params"].include? param) ? data["cpet_params"][param][index_MAX] : data["cpet_results"][param][index_MAX]
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
      ::Subject.find_by(id: data.subject_id)
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
  end # class SummaryTable

end # module Report::Cell
