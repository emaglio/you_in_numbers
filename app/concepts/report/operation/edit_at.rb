class Report::EditAt < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( Report, :find_by )
    step Contract::Build( constant: Report::Contract::EditAt )
  end

  step Nested( Present )
  step Contract::Validate()
  step Contract::Persist()
end
