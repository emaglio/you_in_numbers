module User::Cell

  class GetReportTemplate < Trailblazer::Cell

    def report
      Report.find_by(user_id: -1)
    end

    def obj_array
      model["content"]["report_template"]["custom"]
    end

  end # class GetReportTemplate

end # module User::Cell
