class Report::Show < Trailblazer::Operation
  step Model(Report, :find_by)

end