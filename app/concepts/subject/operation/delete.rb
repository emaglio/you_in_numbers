class Subject::Operation::Delete < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit(::Session::Policy, :subject_owner?)
  failure Session::Lib::ThrowException
  step :delete_reports!
  step :delete!

  def delete_reports!(_options, model:, current_user:, **)
    Report.where(subject_id: model.id).ids.each do |report_id|
      Report::Operation::Delete.(params: { id: report_id }, current_user: current_user)
    end
    true
  end

  def delete!(_options, model:, **)
    model.destroy
  end
end # class Subject::Operation::Delete
