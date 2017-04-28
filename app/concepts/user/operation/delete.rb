require_dependency 'session/lib/throw_exception'

class User::Delete < Trailblazer::Operation
  step Model(User, :find_by)
  step Policy::Pundit( ::Session::Policy, :current_user?)
  failure ::Session::Lib::ThrowException
  # step :notify!
  step :delete_company!
  step :delete_reports!
  step :delete!

  # def notify!(options, model:, **)
  #   Notification::User.({}, "email" => model.email, "type" => "delete")
  # end

  def delete_company!(options, model:, **)
    Company.where("user_id like ?", model.id).each do |company|
      company.destroy
    end
  end

  def delete_reports!(options, model:, **)
    Report.where("user_id like ?", model.id).each do |report|
      report.destroy
    end
  end

  def delete!(options, model:, **)
    model.destroy
  end
end
