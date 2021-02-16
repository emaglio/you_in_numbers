class Subject::Operation::GetReports < Trailblazer::V2_1::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit(::Session::Policy, :subject_owner?)
  fail Session::Lib::ThrowException
  step :get_reports!

  def get_reports!(options, model:, current_user:, **)
    options['reports'] = {
      'id' => model.id,
      'report' => Report.where('user_id like ? AND subject_id like ?', current_user.id, model.id)
    }
  end
end # class Subjects::GerReports
