class Subject::Operation::EditHeightWeight < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit(::Session::Policy, :subject_owner?)
  fail Session::Lib::ThrowException
  step Contract::Build(constant: Subject::Contract::EditHeightWeight)
  step Contract::Validate()
  step Contract::Persist()
end # class Subject::Operation::EditHeightWeight
