class Report::New < Trailblazer::Operation 
  step Model(Report, :new)
  step Contract::Build(constant: Report::Contract::New)    
end