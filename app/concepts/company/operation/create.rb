class Company::Operation::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(Company, :new)
    step Policy::Pundit(::Session::Policy, :signed_in?)
    fail Session::Lib::ThrowException
    step Contract::Build(constant: Company::Contract::New)
  end # class Present

  step Subprocess(Present)
  step Contract::Validate()
  step :upload_image!
  step Contract::Persist()

  def upload_image!(ctx, *)
    return true if ctx['contract.default'].logo == nil
    ctx['contract.default'].logo!(ctx['contract.default'].logo) do |v|
      v.process!(:thumb) { |job| job.thumb!('120x120#') }
    end
  end
end # class Company::Operation::Create
