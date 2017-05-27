require_dependency 'subject/operation/edit'

class Subject::Update < Trailblazer::Operation
  step Nested(Subject::Edit)
  step Contract::Validate()
  step Contract::Persist()
end # class Subject::Update
