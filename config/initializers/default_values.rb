class MyDefault < ActiveRecord::Base
    # make sure to change edit_obj in case you change this
    array = []

    chart = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "VO2", :colour => "#FF2D2D", :show_scale => true},
                          y2: {:name => "VCO2", :colour => "#2D2DFF", :show_scale => false},
                          y3: {:name => nil, :colour => nil, :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 0,
                          show_vo2max: {show: true, colour: "#000000"},
                          show_exer: {show: true, colour: "#F8CA66"},
                          show_AT: {show: true, colour: "#FF2D2D"},
                          only_exer: false)
    chart2 = OpenStruct.new(type: 'report/cell/chart',
                          y1: {:name => "HR", :colour => "#FF2D2D", :show_scale => true},
                          y2: {:name => "Power", :colour => "#2D2DFF", :show_scale => true},
                          y3: {:name => "VE", :colour => "#ED7C52", :show_scale => true},
                          x: {:name => "t", :time => true, :time_format => "mm:ss"},
                          index: 1,
                          show_vo2max: {show: false, colour: "#000000"},
                          show_exer: {show: true, colour: "#F8CA66"},
                          show_AT: {show: true, colour: "#FF2D2D"},
                          only_exer: false)
    summary = OpenStruct.new(type: 'report/cell/vo2max_summary',
                          y1: nil,
                          y2: nil,
                          y3: nil,
                          x: nil,
                          index: 2,
                          show_vo2max: false,
                          show_exer: false,
                          show_AT: false,
                          only_exer: false)
    training_zones = OpenStruct.new(type: 'report/cell/training_zones',
                          y1: nil,
                          y2: nil,
                          y3: nil,
                          x: nil,
                          index: 3,
                          show_vo2max: false,
                          show_exer: false,
                          show_AT: false,
                          only_exer: false)

    array << chart
    array << chart2
    array << summary
    array << training_zones

    ReportObj = array

    ReportPdf = {"logo_size" => 80, "chart_size" => 500}

    SubjectAges = [20,30,40,50,60,70]

    SubjectScores = ["Superior", "Excellent", "Good", "Fair", "Poor", "Very Poor"]

    ACSM_male = [[61.2,56.2,51.1,45.7,42.2,38.1],[58.3,54.3,47.5,44.4,41,36.7],[57,52.9,46.8,42.4,38.4,34.6],[54.3,49.7,43.3,38.3,35.2,31.1],[51.1,46.1,39.5,35,31.4,27.4],[49.7,42.4,36,30.9,28,23.7]]

    ACSM_female = [[55,50.2,44,39.5,35.5,31.6],[52.5,46.9,41,36.7,33.8,29.9],[51.1,45.2,38.9,35.1,31.6,28],[45.3,39.9,35.2,31.4,28.7,25.5],[42.4,36.9,32.3,29.1,26.6,23.7],[42.4,36.7,30.2,26.6,23.8,20.8]]

    # Harris-Benedict equation:
    # BMR = 66.5 + (13.75 x weight in kg) + (5.003 x height in cm) – (6.755 x age in years) (man)
    # BMR = 655.1 + (9.563 x weight in kg) + (1.850 x height in cm) – (4.676 x age in years) (woman)

end
