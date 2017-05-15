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
end
