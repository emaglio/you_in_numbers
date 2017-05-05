module Report::Cell

  class EditOptions < New

    def index
      options[:obj][:index]
    end

    def obj_array_size
      options[:size]
    end

    def chart?
      options[:obj][:type] == 'report/cell/chart'
    end

    # TODO: make this for the tables
    def edit
      button_to "Edit", edit_chart_user_path(current_user.id), method: :get, params: {edit_chart: index}, class: "btn btn-outline btn-warning" if chart?
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
