module Subject::Cell

  class Search < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def subjects
      Subject.where("user_id like ?", current_user.id)
    end

    def subject_array
      array = []

      subjects.each do |subject|
        str = "["
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
        str = str + ("#{button_to "Select", new_report_path, class: "btn btn-outline btn-success", :method => :get, params: {subject_id: subject.id}}".inspect)
        str = str + ("]")
        str = str + (",")
        array << str
      end

      return array
    end

    def create_subject
      button_to "Create a new one", new_subject_path, class: "btn btn-outline btn-success", :method => :get, params: {new_report: true}
    end

  end # class Search

end # module Subject::Cell
