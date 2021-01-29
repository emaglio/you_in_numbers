class Company::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Company, :new)
    step Policy::Pundit(::Session::Policy, :signed_in?)
    failure Session::Lib::ThrowException
    step Contract::Build(constant: Company::Contract::New)
  end # class Present

  step Nested(Present)
  step Contract::Validate()
  step :upload_image!
  step Contract::Persist()

  def upload_image!(options, *)
    return true if options['contract.default'].logo == nil
    options['contract.default'].logo!(options['contract.default'].logo) do |v|
      v.process!(:thumb) { |job| job.thumb!('120x120#') }
    end
  end
end # class Company::Create
