class Company::Operation::Update < Trailblazer::V2_1::Operation
  class Present < Trailblazer::V2_1::Operation
    step Model(Company, :find_by)
    step Policy::Pundit(::Session::Policy, :company_owner?)
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
end # class Company::Operation::Update
