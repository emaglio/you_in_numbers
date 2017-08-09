class Subject::Delete < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit( ::Session::Policy, :subject_owner?)
  failure Session::Lib::ThrowException
  step :delete_reports!
  step :delete!

  def delete_reports!(options, model:, current_user:, **)
    Report.where("subject_id like ?", model.id).each do |report|
      Report::Delete.({id: report.id}, "current_user" => current_user)
    end
  end

  def delete!(options, model:, **)
    model.destroy
  end

end # class Subject::Delete
