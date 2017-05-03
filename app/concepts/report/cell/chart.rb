module Report::Cell

  class Chart < Trailblazer::Cell

     def current_user
      options[:context][:current_user]
    end

    def edit?
      options[:type] == "edit"
    end


    def index
      options[:obj][:index]
    end

    def obj_array_size
      options[:size]
    end

    def edit
      button_to "Edit", edit_chart_user_path(current_user.id), method: :get, params: {edit_chart: index}, class: "btn btn-outline btn-warning"
    end

    def delete
      # button_to "Delete", delete_obj_(model.id), method: :delete, data: {confirm: 'Are you sure?'}, class: "btn btn-outline btn-danger"
    end

    def move_up
      link_to '<i class="fa fa-arrow-up" aria-hidden="true"></i>'.html_safe, edit_obj_user_path(current_user.id, move_up: index), method: :get, class: "btn btn-outline btn-success" if index > 0
    end

    def move_down
      link_to '<i class="fa fa-arrow-down" aria-hidden="true"></i>'.html_safe, edit_obj_user_path(current_user.id, move_down: index), method: :get, class: "btn btn-outline btn-success" if index < (obj_array_size-1)
    end

    def label_1
      options[:obj][:y1][:name].inspect
    end

    def label_2
      options[:obj][:y2][:name].inspect
    end

    def label_3
      options[:obj][:y3][:name].inspect
    end

    def colour_1
      options[:obj][:y1][:colour].inspect
    end

    def colour_2
      options[:obj][:y2][:colour].inspect
    end

    def colour_3
      options[:obj][:y2][:colour].inspect
    end

    def colour_vo2max
      options[:obj][:show_vo2max][:colour].inspect
    end

    def colour_exer
      options[:obj][:show_exer][:colour].inspect
    end

    def colour_at
      options[:obj][:show_AT][:colour].inspect
    end

    def time_format
      options[:obj][:x][:time_format].inspect
    end

    def generate_param_1
      label_1 != "nil"
    end

    def generate_param_2
      label_2 != "nil"
    end

    def generate_param_3
      label_3 != "nil"
    end

    def show_scale_1
      options[:obj][:y1][:show_scale]
    end

    def show_scale_2
      options[:obj][:y2][:show_scale]
    end

    def show_scale_3
      options[:obj][:y3][:show_scale]
    end

    def x_label
      label = options[:obj][:x][:name]
      label = "time" if label == "t"
    end

    def title
      this_title = "#{options[:obj][:y1][:name]}"

      this_title = this_title + " - #{options[:obj][:y2][:name]}" if label_2 != "nil"
      this_title = this_title + " - #{options[:obj][:y3][:name]}" if label_3 != "nil"

      this_title = this_title + " on " + x_label

      return this_title.inspect
    end

    def chart_id
      "canvas-#{options[:obj][:index]}"
    end

    def y1
      model["cpet_params"][options[:obj][:y1][:name]].inspect
    end

    def y2
      model["cpet_params"][options[:obj][:y2][:name]].inspect
    end

    def y3
      model["cpet_params"][options[:obj][:y3][:name]].inspect
    end

    def x
      model["cpet_params"][options[:obj][:x][:name]].inspect
    end

    def x_type
      options[:obj][:x][:time] ? "time".inspect : "linear".inspect
    end

    def at_index
      model["cpet_results"]["at_index"] + model["cpet_results"]["exer_phase"]["starts"]
    end

    def at_value
      model["cpet_params"]["t"][at_index].inspect
    end

    def exer_phase_starts
      model["cpet_results"]["exer_phase"]["starts"]
    end

    def exer_phase_ends
      model["cpet_results"]["exer_phase"]["starts"] + model["cpet_results"]["exer_phase"]["num_steps"]
    end

    def exer_phase
      exer_phase_array = []
      exer_phase_array[0] = model["cpet_params"]["t"][exer_phase_starts].inspect
      exer_phase_array[1] = model["cpet_params"]["t"][exer_phase_ends].inspect

      return exer_phase_array
    end

    # TODO: make this better (maybe get this value from the Chart with js)
    def y_exer_phase #for exersice phase
      array = []
      array[0] = model["cpet_params"][options[:obj][:y1][:name]].max
      array[1] = model["cpet_params"][options[:obj][:y2][:name]].max unless label_2 == "nil"
      array[2] = model["cpet_params"][options[:obj][:y3][:name]].max unless label_3 == "nil"
      array.max > 1000 ? (array.max+200).round(-2) : (array.max+10).round(-1)
    end

    def vo2_max_value
      model["cpet_results"]["vo2_max"]["value"]
    end

    def vo2_max_starts
      index = model["cpet_results"]["vo2_max"]["starts"] + model["cpet_results"]["exer_phase"]["starts"]
      return model["cpet_params"]["t"][index].inspect
    end

    def vo2_max_ends
      index = model["cpet_results"]["vo2_max"]["ends"] + model["cpet_results"]["exer_phase"]["starts"]
      return model["cpet_params"]["t"][index].inspect
    end
  end #class Chart

end # module Report::Cell
