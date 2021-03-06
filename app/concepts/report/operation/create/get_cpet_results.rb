class Report::Operation::Create < Trailblazer::Operation
  class GetCpetResults < Trailblazer::Operation
    step :find_exer_phase!
    step :find_AT!
    step :find_VO2_max!
    step :find_training_zones!
    step :cpet_results!

    def find_exer_phase!(options, cpet_params:, **)
      start_exer = 0
      end_exer = 0

      cpet_params['Phase'].each do |phase|
        start_exer += 1 if (phase != 'EXERCISE') && (phase != 'RECOVERY')
        end_exer += 1 if phase == 'EXERCISE'
      end

      end_exer = end_exer + start_exer - 1

      # hash with starting index of exercise phase and durantion on it (num_steps)
      exer_phase = { 'starts' => start_exer, 'num_steps' => end_exer - start_exer + 1 }

      options['exer_phase'] = exer_phase
    end

    # simply the minimum of the curve VE/VO2 TODO: make sure that it's enough
    def find_AT!(options, cpet_params:, exer_phase:, **)
      exer_array = cpet_params['VE/VO2'][exer_phase['starts'], exer_phase['num_steps']]

      # index in the exercise phase
      # used as restoring point
      options['at_index'] = exer_array.index(exer_array.min)
      # used during editing and showing
      options['edited_at_index'] = exer_array.index(exer_array.min)
    end

    def find_VO2_max!(options, cpet_params:, exer_phase:, **)
      # searching a range of 30 seconds where the max is included
      # starting from the end of the exer phase

      exer_array = cpet_params['VO2'][exer_phase['starts'], exer_phase['num_steps']]

      max_index = exer_array.index(exer_array.max)

      # get the correct time array
      !cpet_params['t'].nil? ? time_array = cpet_params['t'] : time_array = cpet_params['time']
      time_array = time_array[exer_phase['starts'], exer_phase['num_steps']]

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

      max_value = (exer_array[starts, ends - starts + 1].sum.to_f / (ends - starts + 1).to_f).round

      # as max point I use the end of the 30 seconds range
      vo2_max = { 'index' => ends, 'value' => max_value, 'starts' => starts, 'ends' => ends }

      options['vo2_max'] = vo2_max
      options['edited_vo2_max'] = vo2_max.clone
    end

    def find_training_zones!(options, cpet_params:, current_user:, exer_phase:, vo2_max:, **)
      vo2_array = cpet_params['VO2'][exer_phase['starts'], exer_phase['num_steps']]

      # get training zones level from Report settings
      level_array = []
      current_user.content['report_settings']['training_zones_settings'].each do |value|
        level_array << value * 0.01
      end

      index_35 = getValueIndex(vo2_max['value'] * (level_array[0]), vo2_array, 0)
      index_50 = getValueIndex(vo2_max['value'] * (level_array[1]), vo2_array, index_35)
      index_51 = getValueIndex(vo2_max['value'] * (level_array[2]), vo2_array, index_50)
      index_75 = getValueIndex(vo2_max['value'] * (level_array[3]), vo2_array, index_51)
      index_76 = getValueIndex(vo2_max['value'] * (level_array[4]), vo2_array, index_75)
      index_90 = getValueIndex(vo2_max['value'] * (level_array[5]), vo2_array, index_76)
      index_91 = getValueIndex(vo2_max['value'] * (level_array[6]), vo2_array, index_90)
      index_100 = getValueIndex(vo2_max['value'], vo2_array, index_91)

      options['training_zones'] = {
        '35%' => index_35,
        '50%' => index_50,
        '51%' => index_51,
        '75%' => index_75,
        '76%' => index_76,
        '90%' => index_90,
        '91%' => index_91,
        '100%' => index_100
      }
    end

    def cpet_results!(options, exer_phase:, at_index:, edited_at_index:, vo2_max:, edited_vo2_max:, training_zones:, **)
      options['cpet_results'] = {
        'vo2_max' => vo2_max,
        'at_index' => at_index,
        'exer_phase' => exer_phase,
        'edited_at_index' => edited_at_index,
        'edited_vo2_max' => edited_vo2_max,
        'training_zones' => training_zones
      }
    end

    private

    def sec(time)
      zero = Time.parse('00:00:00')
      # make sure that the time string has the same format hh:mm:ss
      time = '00:' + time if time.length >= 5
      time = Time.parse(time)

      return (time - zero).to_i
    end

    def getValueIndex(value, vo2, offset)
      # return the row in the range 3 cells are bigger than the value, check starting with offset
      row_index = offset
      count = 0
      check = 0
      found = false

      while (row_index <= vo2.size) && (found == false)

        if vo2[row_index] > value
          if count == 0
            check = row_index
            count += 1
          else
            if row_index != check + 1
              count = 0
            else
              check = row_index
              count += 1
            end
          end
        end

        found = true if count == 3

        row_index += 1
      end

      return row_index - 1
    end
  end
end
