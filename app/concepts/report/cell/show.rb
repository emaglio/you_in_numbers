module Report::Cell

  class Show < Trailblazer::Cell

    def obj_array
      array = []

      chart = OpenStruct.new(type: 'report/cell/chart',
                            y1: {:name => "VO2", :colour => "rgb(0,0,0", :show_scale => true},
                            y2: {:name => "VCO2", :colour => "rgb(0,0,0", :show_scale => false},
                            y3: {:name => nil, :colour => nil, :show_scale => true},
                            x: {:name => "t", :time => true, :time_format => "mm:ss"},
                            index: 0,
                            show_vo2max: true,
                            show_exer: true,
                            show_AT: true)
      chart2 = OpenStruct.new(type: 'report/cell/chart',
                            y1: {:name => "HR", :colour => "rgb(0,0,0", :show_scale => true},
                            y2: {:name => "Power", :colour => "rgb(0,0,0", :show_scale => true},
                            y3: {:name => "VE", :colour => nil, :show_scale => true},
                            x: {:name => "t", :time => true, :time_format => "mm:ss"},
                            index: 1,
                            show_vo2max: false,
                            show_exer: true,
                            show_AT: true)
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

      array << summary
      array << training_zones
      array << chart
      array << chart2

      return array

    end

  end #class Show

end
