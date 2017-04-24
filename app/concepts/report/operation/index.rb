class Report::Index < Trailblazer::Operation
  step :model!

  def model!(options, current_user:, **)
    options["model"] = Report.where("user_id like ?", current_user.id)
  end


end
