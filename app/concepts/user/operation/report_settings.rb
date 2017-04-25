class User::ReportSettings < Trailblazer::Operation
  step Nested(User::GetReportSettings)
  step Contract::Validate()
  step Contract::Persist()
  step :params_list!
  step :ergo_params_list!
  step :training_zones_settings!
  step :save!

  def params_list!(options, params:, **)
    string = options["model"]["content"]["params_list"]
    options["model"]["content"]["params_list"] = []
    options["model"]["content"]["params_list"] = string.split(',')
  end

  def ergo_params_list!(options, params:, **)
    options["model"]["content"]["ergo_params_list"] = []
    options["model"]["content"]["ergo_params_list"] << params["load_1"].gsub(/\s+/, "")
    options["model"]["content"]["ergo_params_list"] << params["load_1_um"].gsub(/\s+/, "")
    options["model"]["content"]["ergo_params_list"] << params["load_2"].gsub(/\s+/, "")
    options["model"]["content"]["ergo_params_list"] << params["load_2_um"].gsub(/\s+/, "")
  end

  def training_zones_settings!(options, params:, model:, **)
    options["model"]["content"]["training_zones_settings"] = []
    options["model"]["content"]["training_zones_settings"] << 35
    options["model"]["content"]["training_zones_settings"] << params["fat_burning_2"].to_i
    options["model"]["content"]["training_zones_settings"] << params["endurance_1"].to_i
    options["model"]["content"]["training_zones_settings"] << params["endurance_2"].to_i
    options["model"]["content"]["training_zones_settings"] << params["at_1"].to_i
    options["model"]["content"]["training_zones_settings"] << params["at_2"].to_i
    options["model"]["content"]["training_zones_settings"] << params["vo2max_1"].to_i
    options["model"]["content"]["training_zones_settings"] << 100
  end

  def save!(options, model:, **)
    model.save
  end
end # class User::ReportSettings
