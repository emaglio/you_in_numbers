require 'reform/form/dry'

module User::Contract
  class EditChart < Reform::Form
    feature Reform::Form::Dry

    property :title, virtual: true
    property :y1_select, virtual: true
    property :y1_color, virtual: true
    property :y1_scale, virtual: true
    property :y2_select, virtual: true
    property :y2_color, virtual: true
    property :y2_scale, virtual: true
    property :y3_select, virtual: true
    property :y3_color, virtual: true
    property :y3_scale, virtual: true
    property :x, virtual: true
    property :x_time, virtual: true
    property :x_format, virtual: true
    property :vo2_show, virtual: true
    property :vo2_color, virtual: true
    property :exer_show, virtual: true
    property :exer_color, virtual: true
    property :at_show, virtual: true
    property :at_color, virtual: true
    property :plot_exercise_only, virtual: true

    validation do
    end
  end
end
