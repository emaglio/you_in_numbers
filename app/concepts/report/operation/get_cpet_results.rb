class Report::GetCpetResults < Trailblazer::Operation
  step :find_exer_phase!
  step :find_AT!
  step :find_VO2_max!
  step :cpet_results!

  def find_exer_phase!(options, *)
    start_exer = 0
    end_exer = 0

    options["Phase"].each do |phase|
      start_exer += 1 if phase != "EXERCISE" and phase != "RECOVERY"
      end_exer += 1 if phase == "EXERCISE"
    end

    end_exer = end_exer + start_exer - 1

    # hash with starting index of exercise phase and durantion on it (num_steps)
    exer_phase = { "starts" => start_exer, "num_steps" => end_exer - start_exer + 1}

    options["exer_phase"] = exer_phase
  end

  # simply the minimum of the curve VE/VO2 TODO: make sure that it's enough
  def find_AT!(options, exer_phase:, **)
    exer_array = options["VE/VO2"][exer_phase["starts"], exer_phase["num_steps"]]

    # index in the exercise phase
    options["at_index"] = exer_array.index(exer_array.min)
  end

  def find_VO2_max!(options, exer_phase:, **)
    # searching a range of 30 seconds where the max is included
    # starting from the end of the exer phase

    exer_array = options["VO2"][exer_phase["starts"], exer_phase["num_steps"]]

    max_index = exer_array.index(exer_array.max)

    # get the correct time array
    options["t"] != nil ? time_array = options["t"] : time_array = options["time"]
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

    options["vo2_max"] = vo2_max
  end

  def cpet_results!(options, exer_phase:, at_index:, vo2_max:, **)
    options["cpet_results"] = {
      "exer_phase" => exer_phase,
      "at_index" => at_index,
      "vo2_max" => vo2_max
    }
  end


private
  def sec(time)
    zero = Time.parse("00:00:00")
    # make sure that the time string has the same format hh:mm:ss
    time = "00:" + time if time.length >= 5
    time = Time.parse(time)

    return (time - zero).to_i
  end
end