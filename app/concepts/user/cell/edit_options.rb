module User::Cell

  class EditOptions < New

    def index
      options[:obj][:index]
    end

    def obj_array_size
      options[:size]
    end

    def type
      options[:obj][:type]
    end

    def not_training_zones?
      type != 'report/cell/training_zones'
    end

    # TODO: make this for the tables
    def edit
      (type == "report/cell/chart" ? edit_chart : edit_table) if not_training_zones?
    end

    def edit_chart
      button_to "Edit", edit_chart_user_path(current_user.id), method: :get, params: {edit_chart: index}, class: "btn btn-outline btn-warning"
    end

    def edit_table
      button_to "Edit", edit_table_user_path(current_user.id), method: :get, params: {edit_table: index}, class: "btn btn-outline btn-warning"
    end

    def delete
      button_to "Delete", edit_obj_user_path(current_user.id), method: :get, params: {delete: index}, data: {confirm: 'Are you sure?'}, class: "btn btn-outline btn-danger"
    end

    def move_up
      link_to '<i class="fa fa-arrow-up" aria-hidden="true"></i>'.html_safe, edit_obj_user_path(current_user.id, move_up: index), method: :get, class: "btn btn-outline btn-success" if index > 0
    end

    def move_down
      link_to '<i class="fa fa-arrow-down" aria-hidden="true"></i>'.html_safe, edit_obj_user_path(current_user.id, move_down: index), method: :get, class: "btn btn-outline btn-success" if index < (obj_array_size-1)
    end
  end # class EditOptions

end # module User::Cell
