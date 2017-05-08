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
  end

  def default_report_template!(options, model:, **)
    array = []

    chart = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "VO2", :colour => "#FF2D2D", :show_scale => true},
                          y2: {:name => "VCO2", :colour => "#2D2DFF", :show_scale => false},
                          y3: {:name => nil, :colour => nil, :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 0,
                          show_vo2max: {show: true, colour: "#000000"},
                          show_exer: {show: true, colour: "#F8CA66"},
                          show_AT: {show: true, colour: "#FF2D2D"})
    chart2 = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "HR", :colour => "#FF2D2D", :show_scale => true},
                          y2: {:name => "Power", :colour => "#2D2DFF", :show_scale => true},
                          y3: {:name => "VE", :colour => "#ED7C52", :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 1,
                          show_vo2max: {show: false, colour: "#000000"},
                          show_exer: {show: true, colour: "#F8CA66"},
                          show_AT: {show: true, colour: "#FF2D2D"})
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

    options["contract.default"].content.report_template.custom = array
    options["contract.default"].content.report_template.not_custom = array
  end

  def create!(options, model:, params:, **)
    auth = Tyrant::Authenticatable.new(model)
    auth.digest!(params[:password]) # contract.auth_meta_data.password_digest = ..
    auth.confirmed!
    auth.sync
    model.save
  end

end
