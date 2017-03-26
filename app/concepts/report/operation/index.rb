class Report::Index < Trailblazer::Operation
  step :model!

  def model!(options, *)
    options["model"] = Report.all
  end

  
end