class User::ReportSettings < Trailblazer::Operation
  step Nested(User::GetReportSettings)
  step Contract::Validate()
  step :params_list!
  step :ergo_params_list!
  step :training_zones_settings!
  step Contract::Persist()

  def params_list!(options, params:, **)
    string = params["params_list"]
    options["contract.default"].content.report_settings.params_list = []
    options["contract.default"].content.report_settings.params_list = string.split(',')
  end

  def ergo_params_list!(options, params:, **)
    options["contract.default"].content.report_settings.params_list = []
    options["contract.default"].content.report_settings.ergo_params_list << params["load_1"].gsub(/\s+/, "")
    options["contract.default"].content.report_settings.ergo_params_list << params["load_1_um"].gsub(/\s+/, "")
    options["contract.default"].content.report_settings.ergo_params_list << params["load_2"].gsub(/\s+/, "")
    options["contract.default"].content.report_settings.ergo_params_list << params["load_2_um"].gsub(/\s+/, "")
  end

  def training_zones_settings!(options, params:, model:, **)
    options["contract.default"].content.report_settings.training_zones_settings = []
    options["contract.default"].content.report_settings.training_zones_settings << 35
    options["contract.default"].content.report_settings.training_zones_settings << params["fat_burning_2"].to_i
    options["contract.default"].content.report_settings.training_zones_settings << params["endurance_1"].to_i
    options["contract.default"].content.report_settings.training_zones_settings << params["endurance_2"].to_i
    options["contract.default"].content.report_settings.training_zones_settings << params["at_1"].to_i
    options["contract.default"].content.report_settings.training_zones_settings << params["at_2"].to_i
    options["contract.default"].content.report_settings.training_zones_settings << params["vo2max_1"].to_i
    options["contract.default"].content.report_settings.training_zones_settings << 100
  end

end # class User::ReportSettings
