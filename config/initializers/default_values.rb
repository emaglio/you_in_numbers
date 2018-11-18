module MyDefault
  # make sure to change edit_obj in case you change this
  ReportObj = []

  Subject = OpenStruct.new(type: 'report/cell/subject',
                            index: "subject")

  chart = OpenStruct.new(type: 'report/cell/chart',
                        title: "VO2 and VCO2 on time",
                        y1: { :name => "VO2", :colour => "#FF2D2D", :show_scale => "1" },
                        y2: { :name => "VCO2", :colour => "#2D2DFF", :show_scale => "0" },
                        y3: { :name => nil, :colour => nil, :show_scale => "0" },
                        x: { :name => "t", :time => "1", :time_format => "mm:ss" },
                        index: 0,
                        show_vo2max: { show: "1", colour: "#000000" },
                        show_exer: { show: "1", colour: "#F8CA66" },
                        show_AT: { show: "1", colour: "#FF2D2D" },
                        only_exer: "0")
  chart2 = OpenStruct.new(type: 'report/cell/chart',
                        title: "HR, Power and Ve on time",
                        y1: { :name => "HR", :colour => "#FF2D2D", :show_scale => "1" },
                        y2: { :name => "Power", :colour => "#2D2DFF", :show_scale => "1" },
                        y3: { :name => "VE", :colour => "#ED7C52", :show_scale => "1" },
                        x: { :name => "t", :time => "1", :time_format => "mm:ss" },
                        index: 1,
                        show_vo2max: { show: "0", colour: "#000000" },
                        show_exer: { show: "1", colour: "#F8CA66" },
                        show_AT: { show: "1", colour: "#FF2D2D" },
                        only_exer: "0")
  summary = OpenStruct.new(type: 'report/cell/summary_table',
                        title: "VO2max Test Summary",
                        index: 2,
                        params_list: "t,RQ,VO2,VO2/Kg,HR,Power,Revolution",
                        params_unm_list: "mm:ss,-,l/min,ml/min/Kg,bpm,watt,BPM")
  training_zones = OpenStruct.new(type: 'report/cell/training_zones',
                        title: "Training Zones",
                        index: 3)

  ReportObj << chart
  ReportObj << chart2
  ReportObj << summary
  ReportObj << training_zones

  ReportPdf = { "logo_size" => 80, "chart_size" => 500 }

  SubjectAges = [20,30,40,50,60,70]

  SubjectScores = ["Superior", "Excellent", "Good", "Fair", "Poor", "Very Poor"]

  ACSM_male = [
    [61.2,56.2,51.1,45.7,42.2,38.1],
    [58.3,54.3,47.5,44.4,41,36.7],
    [57,52.9,46.8,42.4,38.4,34.6],
    [54.3,49.7,43.3,38.3,35.2,31.1],
    [51.1,46.1,39.5,35,31.4,27.4],
    [49.7,42.4,36,30.9,28,23.7]
  ]

  ACSM_female = [
    [55,50.2,44,39.5,35.5,31.6],
    [52.5,46.9,41,36.7,33.8,29.9],
    [51.1,45.2,38.9,35.1,31.6,28],
    [45.3,39.9,35.2,31.4,28.7,25.5],
    [42.4,36.9,32.3,29.1,26.6,23.7],
    [42.4,36.7,30.2,26.6,23.8,20.8]
  ]

  # Harris-Benedict equation:
  # BMR = 66.5 + (13.75 x weight in kg) + (5.003 x height in cm) – (6.755 x age in years) (man)
  # BMR = 655.1 + (9.563 x weight in kg) + (1.850 x height in cm) – (4.676 x age in years) (woman)

  EditATObj = []

  EditATObj << OpenStruct.new(type: 'report/cell/chart',
                        title: "VCO2 on VO2",
                        y1: { :name => "VCO2", :colour => "#FF2D2D", :show_scale => "1" },
                        y2: { :name => nil, :colour => "#000000", :show_scale => "0" },
                        y3: { :name => nil, :colour => "#000000", :show_scale => "0" },
                        x: { :name => "VO2", :time => "0", :time_format => "mm:ss" },
                        index: 0,
                        show_vo2max: { show: "0", colour: "#000000" },
                        show_exer: { show: "1", colour: "#000000" },
                        show_AT: { show: "1", colour: "#FF2D2D" },
                        only_exer: "1")
  EditATObj << OpenStruct.new(type: 'report/cell/chart',
                        title: "VE/VCO2 and VE/VO2 on time",
                        y1: { :name => "VE/VCO2", :colour => "#FF2D2D", :show_scale => "1" },
                        y2: { :name => "VE/VO2", :colour => "#2D2DFF", :show_scale => "1" },
                        y3: { :name => nil, :colour => "#000000", :show_scale => "0" },
                        x: { :name => "t", :time => "1", :time_format => "mm:ss" },
                        index: 1,
                        show_vo2max: { show: "0", colour: "#000000" },
                        show_exer: { show: "0", colour: "#000000" },
                        show_AT: { show: "1", colour: "#FF2D2D" },
                        only_exer: "1")

  EditVO2MaxObj = []

  EditVO2MaxObj << OpenStruct.new(type: 'report/cell/chart',
                        title: "VO2 on time",
                        y1: { :name => "VO2", :colour => "#FF2D2D", :show_scale => "1" },
                        y2: { :name => nil, :colour => "#2D2DFF", :show_scale => "1" },
                        y3: { :name => nil, :colour => "#000000", :show_scale => "0" },
                        x: { :name => "t", :time => "1", :time_format => "mm:ss" },
                        index: 0,
                        show_vo2max: { show: "1", colour: "#000000" },
                        show_exer: { show: "1", colour: "#F8CA66" },
                        show_AT: { show: "0", colour: "#FF2D2D" },
                        only_exer: "0")
end
