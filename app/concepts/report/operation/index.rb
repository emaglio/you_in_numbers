class Report::Index < Trailblazer::Operation
  step Policy::Pundit(::Session::Policy, :signed_in?)
  failure ::Session::Lib::ThrowException
  step :model!

  def model!(options, current_user:, **)
    options["model"] = Report.where("user_id like ?", current_user.id)
  end


end
