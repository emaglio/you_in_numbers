module User::Cell

  class GetReportTemplate < Trailblazer::Cell

    def default_report
      Report.find_by(user_id: -1)
    end

  end # class GetReportTemplate

end # module User::Cell
