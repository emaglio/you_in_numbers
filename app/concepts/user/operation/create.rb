require_dependency 'user/operation/new'

class User::Create < Trailblazer::Operation
  step Nested(::User::New)
  step Contract::Validate()
  step :default_report_settings!
  step :default_report_template!
  step Contract::Persist()
  step :create!
  # step :notify!

  # def notify!(options, model:, **)
  #   Notification::User.({}, "email" => model.email, "type" => "welcome")
  # end

  def default_report_settings!(options, *)
    options["contract.default"].content.report_settings.params_list = ["t", "Rf", "VE", "VO2", "VCO2", "RQ", "VE/VO2", "HR", "VO2/Kg", "FAT%", "CHO%", "Phase"]
    options["contract.default"].content.report_settings.ergo_params_list = ["Power", "Watt", "Revolution", "RPM"]
    options["contract.default"].content.report_settings.training_zones_settings = [35, 50, 51, 75, 76, 90, 91, 100]
    options["contract.default"].content.report_settings.units_of_measurement = {"height" => "cm", "weight" => "kg"}
  end

  def default_report_template!(options, model:, **)
    options["contract.default"].content.report_template.custom = MyDefault::ReportObj.clone
    options["contract.default"].content.report_template.default = MyDefault::ReportObj
  end

  def create!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:password]) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end

end
