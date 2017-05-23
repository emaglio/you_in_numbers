require_dependency 'subject/operation/new'

class Subject::Create < Trailblazer::Operation
  step Nested(Subject::New)
  step Contract::Validate()
  step Contract::Persist()
end # class Subject::Create
