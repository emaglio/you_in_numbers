class Subject::Edit < Trailblazer::Operation
  step Model(Subject, :find_by)
  step Policy::Pundit( ::Session::Policy, :report_company_owner?)
  failure Session::Lib::ThrowException
  step Contract::Build(constant: Subject::Contract::Edit)
end # class Subject::New
