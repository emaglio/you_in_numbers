class Subject::EditHeightWeight < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit( ::Session::Policy, :subject_owner?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Subject::Contract::EditHeightWeight)
  step Contract::Validate()
  step Contract::Persist()
end # class Subject::EditHeightWeight
