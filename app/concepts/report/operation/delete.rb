class Report::Delete < Trailblazer::Operation
  step Model(Report, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
  step :delete!

  def delete!(options, model:, **)
    model.destroy
  end

end
