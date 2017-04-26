module Report::Cell

  class Show < Trailblazer::Cell

    def obj_array
      array = []

      chart = OpenStruct.new(type: 'report/cell/chart',
                            y1: {:name => "VO2", :colour => "rgb(0,0,0", :show_scale => true},
                            y2: {:name => "VCO2", :colour => "rgb(0,0,0", :show_scale => true},
                            y3: {:name => nil, :colour => nil, :show_scale => true},
                            x: {:name => "t", :time => true},
                            index: 0,
                            show_vo2max: true,
                            show_exer: true,
                            show_AT: true)
      chart2 = OpenStruct.new(type: 'report/cell/chart', y1: "HR", y2: "Power", x: "t", index: 1)
      summary = obj = OpenStruct.new(type: "report/cell/vo2max_summary", y1: nil, y2: nil, x: nil, index: 2)
      training_zones = OpenStruct.new(type: "report/cell/training_zones", y1: nil, y2: nil, x: nil, index: 3)

      array << chart
      array << chart2
      array << summary
      array << training_zones

      return array

    end

  end #class Show

end
