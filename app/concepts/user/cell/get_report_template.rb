module User::Cell

  class GetReportTemplate < Trailblazer::Cell

    def report
      user_reports = Report.where("user_id like ?", model.id)
      user_reports.size > 0 ? user_reports.last : Report.find_by(user_id: 1)
    end

    def obj_array
      model["content"]["report_template"]["custom"]
    end

  end # class GetReportTemplate

end # module User::Cell
