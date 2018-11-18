module Subject::Cell

  class GetReports < Trailblazer::Cell
    def create_report
      button_to "Create Report", new_report_path, class: "btn btn-outline btn-success", :method => :get,
        params: { subject_id: model["id"] }
    end

    def array
      string = "["
      if model["report"].size == 0
        str = "{ "
        str += "Created".inspect + " : "
        str += "No Data".inspect
        str += ", "
        str += "Title".inspect + " : "
        str += " ".inspect
        str += "}"
        str += ", "
        string += str
      else
        model["report"].each do |report|
          str = "{ "
          str += "Created".inspect + " : "
          str += "#{report.created_at.strftime("%d %B %Y")}".inspect
          str += ", "
          str += "Title".inspect + " : "
          str += "#{link_to report.title, report_path(report)}".inspect
          str += "} "
          str += ", "
          string += str
        end
      end

      str = "{ "
      str += "Created".inspect + " : "
      str += " ".inspect
      str += " , "
      str += "Title".inspect + " : "
      str += "#{create_report}".inspect
      str += "} "

      string += str + "]"
      return string
    end

  end # class GetReports

end # module Subject::Cell
