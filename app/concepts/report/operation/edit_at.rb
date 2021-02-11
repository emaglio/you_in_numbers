class Report::Operation::EditAt < Trailblazer::V2_1::Operation
  class Present < Trailblazer::V2_1::Operation
    step Model(Report, :find_by)
    step Policy::Pundit(::Session::Policy, :report_owner?)
    fail Session::Lib::ThrowException
    step Contract::Build(constant: Report::Contract::EditAt)
  end

  step Subprocess(Present)
  step Contract::Validate()
  step :update_at!
  step Contract::Persist()

  def update_at!(_options, params:, model:, **)
    model['cpet_results']['edited_at_index'] = params['at_position'].to_i
  end
end
