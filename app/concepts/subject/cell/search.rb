module Subject::Cell

  class Search < Trailblazer::Cell

    def current_user
      return options[:context][:current_user]
    end

    def subjects
      Subject.where("user_id like ?", current_user.id)
    end

    def subject_array
      array = ""
      index = 0
      subjects.each do |subject|
        temp = []
        temp << subject.firstname
        temp << subject.lastname
        temp << subject.dob.strftime("%d %B %Y")
        temp << subject.height.to_s
        temp << subject.weight.to_s
        temp << (button_to "Select", new_report_path, class: "btn btn-outline btn-success", :method => :get,
          params: { subject_id: subject.id })
        (index >= 1) ? array += "," : array
        array +=  temp.to_json
        index += 1
      end

      return array
    end

    def create_subject
      button_to "Create a new one", new_subject_path, class: "btn btn-outline btn-success", :method => :get,
        params: { new_report: true }
    end

  end # class Search

end # module Subject::Cell
