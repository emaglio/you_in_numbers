require_dependency 'session/lib/throw_exception'

class Subject::Index < Trailblazer::Operation
  step Policy::Pundit( ::Session::Policy, :signed_in?)
  failure ::Session::Lib::ThrowException
  step :model!

  def model!(options, current_user:, **)
    options[:model] = Subject.where("user_id like ?", current_user.id)
  end
end # class Subject::Index
