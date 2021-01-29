module Subject::Cell
  class Show < New
    def dob
      model.dob.strftime('%d/%b/%Y')
    end

    def edit
      button_to('Edit', edit_subject_path(model), class: 'btn btn-outline btn-warning', :method => :get)
    end

    def delete
      button_to('Delete', subject_path(model.id), method: :delete, data: { confirm: 'Are you sure?' },
                                                  class: 'btn btn-outline btn-danger')
    end

    def height
      "Height (#{current_user.content['report_settings']['units_of_measurement']['height']})"
    end

    def weight
      "Weight (#{current_user.content['report_settings']['units_of_measurement']['weight']})"
    end
  end # class Show
end # module Subject::Cell
