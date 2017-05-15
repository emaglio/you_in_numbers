require_dependency 'company/operation/new'

class Company::Create < Trailblazer::Operation
  step Nested(Company::New)
  step Contract::Validate()
  step :upload_image!
  step Contract::Persist()

  def upload_image!(options, *)
    return true if options["contract.default"].logo == nil
    options["contract.default"].logo!(options["contract.default"].logo) do |v|
      v.process!(:thumb) { |job| job.thumb!("120x120#") }
    end
  end
end # class Company::Create
