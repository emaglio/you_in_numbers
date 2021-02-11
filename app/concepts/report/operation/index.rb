class Report::Operation::Index < Trailblazer::V2_1::Operation
  step Policy::Pundit(::Session::Policy, :signed_in?)
  fail ::Session::Lib::ThrowException
  step :model!

  def model!(options, current_user:, **)
    options['model'] = Report.where(user_id: current_user.id)
  end
end
