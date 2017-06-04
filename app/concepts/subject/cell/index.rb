module Subject::Cell

  class Index < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def total
      Subject.where("user_id like ?", current_user.id).size
    end

    def subject_array
      array = []

      model.each do |subject|
        str = "[ null,"
        str = str + ("#{subject.id.inspect}")
        str = str + (",")
        str = str + ("#{subject.firstname.inspect}")
        str = str + (",")
        str = str + ("#{subject.lastname.inspect}")
        str = str + (",")
        str = str + ("#{subject.dob.strftime("%d %B %Y").inspect}")
        str = str + (",")
        str = str + ("#{subject.height.to_s.inspect}")
        str = str + (",")
        str = str + ("#{subject.weight.to_s.inspect}")
        str = str + (",")
        str = str + ("#{button_to "Open", subject_path(subject), class: "btn btn-outline btn-success", :method => :get}".inspect)
        str = str + (",")
        str = str + ("#{button_to "Edit", edit_subject_path(subject), class: "btn btn-outline btn-warning", :method => :get}".inspect)
        str = str + (",")
        str = str + ("#{button_to "Delete", subject_path(subject.id), method: :delete, data: {confirm: 'Are you sure?'}, class: "btn btn-outline btn-danger"}".inspect)
        str = str + ("]")
        str = str + (",")
        array << str
      end

      return array
    end

    def create_subject
      button_to "Create Subject", new_subject_path, class: "btn btn-outline btn-success", :method => :get
    end

    def create_report
      (button_to "Create Report", new_report_path, class: "btn btn-outline btn-success", :method => :get, params: {subject_id: model.id}).inspect
    end

    def um_height
      current_user.content["report_settings"]["units_of_measurement"]["height"]
    end

    def um_weight
      current_user.content["report_settings"]["units_of_measurement"]["weight"]
    end

  end # class Index

end # module Subject::Cell
