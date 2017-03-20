require 'more_help'
require 'roo'

# class ReportTest < MiniTest::Spec



#   cpet_path = './app/assets/files/cpet.xlsx'

#   cpet_file = Roo::Spreadsheet.open(cpet_path)

#   puts get_data_sheet(cpet_file)
  
# end

class GetResults

  # string time to integer seconds
  def sec(time)
    zero = Time.parse("00:00:00")
    time = "00:" + time if time.length >= 5
    time = Time.parse(time)

    return (time - zero).to_i
  end

  def find_exercise_phase(params)
    start_exer = 0
    end_exer = 0

    params["Phase"].each do |phase|
      start_exer += 1 if phase != "EXERCISE" and phase != "RECOVERY"
      end_exer += 1 if phase == "EXERCISE"
    end

    end_exer = end_exer + start_exer - 1

    # hash with starting index of exercise phase and durantion on it (num_steps)
    exer_phase = { "starts" => start_exer, "num_steps" => end_exer - start_exer + 1}

    return exer_phase
  end

  def find_AT(params, exer_phase)
    exer_array = params["VE/VO2"][exer_phase["starts"], exer_phase["num_steps"]]

    return exer_array.index(exer_array.min)
  end

  def find_VO2_max(params, exer_phase)
    # searching a range of 30 seconds where the max is included
    # starting from the end of the exer phase

    exer_array = params["VO2"][exer_phase["starts"], exer_phase["num_steps"]]

    max_index = exer_array.index(exer_array.max)

    # get the correct time array
    params["t"] != nil ? time_array = params["t"] : time_array = params["time"]
    time_array = time_array[exer_phase["starts"], exer_phase["num_steps"]]

    # last index
    ends = time_array.size - 1
    starts = ends

    time_array.each do
      # check if I have at least a range of 30 seconds
      if (sec(time_array[ends]) - sec(time_array[starts])) >= 30
        # check if the max value is in the range
        if max_index.between?(starts, ends)
          break 
        else
          # move the range back in time
          ends -= 1
          starts -= 1
        end

      else
        # enlarge range
        starts -= 1
      end
    end

    max_value = ((exer_array[starts, ends-starts+1].sum).to_f / (ends-starts+1).to_f).round

    # as max point I use the end of the 30 seconds range
    vo2_max = {"index" => ends, "value" => max_value}

    return vo2_max
  end

  
end

class Test
  GetData = GetData.new
  GetResults = GetResults.new

  cpet_path = './app/assets/files/cpet.xlsx'

  cpet_file = Roo::Spreadsheet.open(cpet_path)

  GetData::set_default_sheet(cpet_file)

  params = []
  params = GetData::cpet_params(cpet_file)

  exer_phase = []
  exer_phase = GetResults::find_exercise_phase(params)
  
  GetResults::find_AT(params, exer_phase)
  GetResults::find_VO2_max(params, exer_phase)



end