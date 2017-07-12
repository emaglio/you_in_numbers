require 'reform/form/dry'

module User::Contract
  class EditChart < Reform::Form
    feature Reform::Form::Dry

    property :edit_chart, virtual: true #used as index
    property :title, virtual: true
    property :y1_select, virtual: true
    property :y1_colour, virtual: true
    property :y1_scale, virtual: true
    property :y2_select, virtual: true
    property :y2_colour, virtual: true
    property :y2_scale, virtual: true
    property :y3_select, virtual: true
    property :y3_colour, virtual: true
    property :y3_scale, virtual: true
    property :x, virtual: true
    property :x_time, virtual: true
    property :x_format, virtual: true
    property :vo2max_show, virtual: true
    property :vo2max_colour, virtual: true
    property :exer_show, virtual: true
    property :exer_colour, virtual: true
    property :at_show, virtual: true
    property :at_colour, virtual: true
    property :only_exer, virtual: true

    validation do
    end
  end
end
