class Report::EditVO2Max < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Report, :find_by)
    step Policy::Pundit(::Session::Policy, :report_owner?)
    failure Session::Lib::ThrowException
    step Contract::Build(constant: Report::Contract::EditVO2Max)
  end

  step Nested(Present)
  step Contract::Validate()
  step :update_vo2max!
  step Contract::Persist()

  def update_vo2max!(_options, params:, model:, **)
    model["cpet_results"]["edited_vo2_max"]["value"] = params["vo2max_value"].to_i
    model["cpet_results"]["edited_vo2_max"]["starts"] = params["vo2max_starts"].to_i
    model["cpet_results"]["edited_vo2_max"]["index"] = params["vo2max_ends"].to_i
    model["cpet_results"]["edited_vo2_max"]["ends"] = params["vo2max_ends"].to_i
  end
end
