module Report::Cell

  class Index < Trailblazer::Cell

    def total
      model.size
    end


    def report_array
      array = ""
      index = 0


      model.each do |report|

        subject = ::Subject.find_by(id: report.subject_id)

        temp = []
        temp << report.id.to_s
        temp << report.title
        temp << report.created_at.strftime("%d %B %Y")
        temp << subject.firstname
        temp << subject.lastname
        temp << subject.dob.strftime("%d %B %Y")
        temp << (button_to "Open", report_path(report.id), class: "btn btn-outline btn-success", :method => :get)
        temp << (button_to "Delete", report_path(report.id), method: :delete, data: { confirm: 'Are you sure?' },
          class: "btn btn-outline btn-danger")
        (index >= 1) ? array += "," : array
        array +=  temp.to_json
        index += 1
      end

      return array
    end

  end

end
