class User::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model(User, :new)
    step Contract::Build(constant: User::Contract::New)
  end

  step Nested(Present)
  step Contract::Validate()
  step :default_report_settings!
  step :default_report_template!
  step Contract::Persist()
  step :create!
  # TODO: add email notification

  # TODO: moves this constant in MyDefault
  def default_report_settings!(options, *)
    options["contract.default"].content.report_settings.params_list = [
      "t", "Rf", "VE", "VO2", "VCO2", "RQ", "VE/VO2", "VE/VCO2", "HR", "VO2/Kg", "FAT%", "CHO%", "Phase"
    ]
    options["contract.default"].content.report_settings.ergo_params_list = ["Power", "Watt", "Revolution", "RPM"]
    options["contract.default"].content.report_settings.training_zones_settings = [35, 50, 51, 75, 76, 90, 91, 100]
    options["contract.default"].content.report_settings.units_of_measurement = { "height" => "cm", "weight" => "kg" }
  end

  def default_report_template!(options, *)
    options["contract.default"].content.report_template.custom = MyDefault::ReportObj.clone
    options["contract.default"].content.report_template.default = MyDefault::ReportObj.clone
  end

  def create!(_options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:password]) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end

end
