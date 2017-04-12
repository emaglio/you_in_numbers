class Report::New < Trailblazer::Operation
  step Model(Report, :new)
  step Policy::Pundit( ::Session::Policy, :signed_in?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Report::Contract::New)
end
