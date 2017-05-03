require_dependency 'user/operation/new'

class User::Create < Trailblazer::Operation
  step Nested(::User::New)
  step Contract::Validate()
  step Contract::Persist()
  step :default_report_settings!
  step :default_report_template!
  step :create!
  # step :notify!

  # def notify!(options, model:, **)
  #   Notification::User.({}, "email" => model.email, "type" => "welcome")
  # end

  def default_report_settings!(options, model:, **)
    model["content"]["report_settings"]["params_list"] = ["t", "Rf", "VE", "VO2", "VCO2", "RQ", "VE/VO2", "HR", "VO2/Kg", "FAT%", "CHO%", "Phase"]
    model["content"]["report_settings"]["ergo_params_list"] = ["Power", "Watt", "Revolution", "RPM"]
    model["content"]["report_settings"]["training_zones_settings"] = [35, 50, 51, 75, 76, 90, 91, 100]
  end

  def default_report_template!(options, model:, **)
    array = []

    chart = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "VO2", :colour => "rgb(0,0,0)", :show_scale => true},
                          y2: {:name => "VCO2", :colour => "rgb(0,0,0)", :show_scale => false},
                          y3: {:name => nil, :colour => nil, :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 0,
                          show_vo2max: {show: true, colour: "rgb(0,0,0)"},
                          show_exer: {show: true, colour: "rgb(0,0,0)"},
                          show_AT: {show: true, colour: "rgb(0,0,0)"})
    chart2 = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "HR", :colour => "rgb(0,0,0)", :show_scale => true},
                          y2: {:name => "Power", :colour => "rgb(0,0,0)", :show_scale => true},
                          y3: {:name => "VE", :colour => nil, :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 1,
                          show_vo2max: {show: false, colour: "rgb(0,0,0)"},
                          show_exer: {show: true, colour: "rgb(0,0,0)"},
                          show_AT: {show: true, colour: "rgb(0,0,0)"})
    summary = OpenStruct.new(type: 'report/cell/vo2max_summary',
                          y1: nil,
                          y2: nil,
                          y3: nil,
                          x: nil,
                          index: 2,
                          show_vo2max: false,
                          show_exer: false,
                          show_AT: false)
    training_zones = OpenStruct.new(type: 'report/cell/training_zones',
                          y1: nil,
                          y2: nil,
                          y3: nil,
                          x: nil,
                          index: 3,
                          show_vo2max: false,
                          show_exer: false,
                          show_AT: false)

    array << chart
    array << chart2
    array << summary
    array << training_zones

    model["content"]["report_template"]["strict"] = array
    model["content"]["report_template"]["custom"] = array
  end

  def create!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:password]) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end

end
