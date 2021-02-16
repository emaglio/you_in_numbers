class Report::Operation::Delete < Trailblazer::Operation
  step Model(Report, :find_by)
  step Policy::Pundit(::Session::Policy, :report_owner?)
  fail Session::Lib::ThrowException
  step :delete!

  def delete!(_options, model:, **)
    model.destroy
  end
end
