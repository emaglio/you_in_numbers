class User::DeleteReportSettings < Trailblazer::Operation
  step Model(User, :find_by)
  step :delete!

  def delete!(options, model:, **)
    model["content"]["report_settings"] = nil
    model.save
  end

end # class User::DeleteReportSettings
