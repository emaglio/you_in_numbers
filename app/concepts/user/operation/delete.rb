require_dependency 'session/lib/throw_exception'

class User::Operation::Delete < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit(::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException
  # step :notify!
  step :delete_company!
  step :delete_reports!
  step :delete_subjects!
  step :delete!

  # def notify!(options, model:, **)
  #   Notification::User.({}, "email" => model.email, "type" => "delete")
  # end

  def delete_company!(_options, model:, current_user:, **)
    Company.where(user_id: model.id).each do |company|
      Company::Operation::Delete.(params: { id: company.id }, current_user: current_user)
    end
  end

  def delete_reports!(_options, model:, current_user:, **)
    Report.where(user_id: model.id).each do |report|
      Report::Operation::Delete.(params: { id: report.id }, current_user: current_user)
    end
  end

  def delete_subjects!(_options, model:, current_user:, **)
    Subject.where(user_id: model.id).each do |subject|
      Subject::Operation::Delete.({ id: subject.id }, 'current_user' => current_user)
    end
  end

  def delete!(_options, model:, **)
    model.destroy
  end
end
