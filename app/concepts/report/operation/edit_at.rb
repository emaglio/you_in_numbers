class Report::EditAt < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( Report, :find_by )
    step Contract::Build( constant: Report::Contract::EditAt )
  end

  step Nested( Present )
  step Contract::Validate()
  step :update_at!
  step Contract::Persist()

  def update_at!(options, params:, model:, **)
    model["cpet_results"]["edited_at_index"] = params["at_position"].to_i
  end
end
