module Subject::Cell

  class Index < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def total
      Subject.where(user_id: current_user.id).size
    end

    def subject_array
      array = ""
      index = 0
      model.each do |subject|
        temp = []
        temp << " "
        temp << subject.id.to_s
        temp << subject.firstname
        temp << subject.lastname
        temp << subject.dob.strftime("%d %B %Y")
        temp << subject.height.to_s
        temp << subject.weight.to_s
        temp << (button_to "Open", subject_path(subject), class: "btn btn-outline btn-success", :method => :get)
        temp << (button_to "Edit", edit_subject_path(subject), class: "btn btn-outline btn-warning", :method => :get)
        temp << (button_to "Delete", subject_path(subject.id),
          method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-outline btn-danger")
        (index >= 1) ? array += "," : array
        array +=  temp.to_json
        index += 1
      end

      return array
    end

    def create_subject
      button_to "Create Subject", new_subject_path, class: "btn btn-outline btn-success", :method => :get
    end

    def create_report
      (
        button_to "Create Report", new_report_path, class: "btn btn-outline btn-success", :method => :get,
        params: { subject_id: model.id }
      ).inspect
    end

    def um_height
      current_user.content["report_settings"]["units_of_measurement"]["height"]
    end

    def um_weight
      current_user.content["report_settings"]["units_of_measurement"]["weight"]
    end
  end # class Index
end # module Subject::Cell
