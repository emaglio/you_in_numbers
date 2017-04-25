require_dependency 'user/operation/new'

class User::Create < Trailblazer::Operation
  step Nested(::User::New)
  step Contract::Validate()
  step Contract::Persist()
  step :default_report_settings!
  step :create!
  # step :notify!

  # def notify!(options, model:, **)
  #   Notification::User.({}, "email" => model.email, "type" => "welcome")
  # end

  def default_report_settings!(options, model:, **)
    model["content"]["params_list"] = ["t", "Rf", "VE", "VO2", "VCO2", "RQ", "VE/VO2", "HR", "VO2/Kg", "FAT%", "CHO%", "Phase"]
    model["content"]["ergo_params_list"] = ["Power", "Watt", "Revolution", "RPM"]
    model["content"]["training_zones_settings"] = [35, 50, 51, 75, 76, 90, 91, 100]
  end

  def create!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:password]) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end
end
