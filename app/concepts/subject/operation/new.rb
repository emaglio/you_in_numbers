class Subject::New < Trailblazer::Operation
  step Model(Subject, :new)
  step Policy::Pundit( ::Session::Policy, :signed_in?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Subject::Contract::New)
end # class Subject::New
