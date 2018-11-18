class Subject::GetReports < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit(::Session::Policy, :subject_owner?)
  failure Session::Lib::ThrowException
  step :get_reports!

  def get_reports!(options, model:, current_user:, **)
    options["reports"] = {
      "id"     => model.id,
      "report" => Report.where("user_id like ? AND subject_id like ?", current_user.id, model.id)
    }
  end
end # class Subjects::GerReports
