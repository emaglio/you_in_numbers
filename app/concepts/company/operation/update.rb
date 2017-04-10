class Company::Update < Trailblazer::Operation
  step Nested(Company::Edit)
  step Contract::Validate()
  step :upload_image!
  step Contract::Persist()

  def upload_image!(options, *)
    return true if options["contract.default"].logo == ""
    options["contract.default"].logo!(options["contract.default"].logo) do |v|
      v.process!(:original)
      v.process!(:thumb) { |job| job.thumb!("120x120#") }
    end
  end
end # class Company::Update
