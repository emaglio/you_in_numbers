module Subject::Cell

  class GetReports < Trailblazer::Cell
    def array
      return "No data" if model["report"].size == 0
      array = []

      model["report"].each do |report|
        array2 = []
        array2 << ("#{report.created_at.strftime("%d %B %Y").inspect}")
        array2 << ("#{link_to report.title, report_path(report)}")
        array << array2
      end

      return array
    end

    def create_report
      button_to "Create Report", new_report_path, class: "btn btn-outline btn-success", :method => :get, params: {subject_id: model["id"]}
    end

    def text_data
      return {"array": array, "link": create_report}
    end
  end # class GetReports

end # module Subject::Cell
