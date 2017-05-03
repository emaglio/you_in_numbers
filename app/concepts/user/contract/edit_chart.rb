require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class EditChart < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :y1_name, virtual: true
    property :y1_colour, virtual: true
    property :y1_show_scale, virtual: true
    property :y2_name, virtual: true
    property :y2_colour, virtual: true
    property :y2_show_scale, virtual: true
    property :y3_name, virtual: true
    property :y3_colour, virtual: true
    property :y3_show_scale, virtual: true
    property :x_name, virtual: true
    property :x_time, virtual: true
    property :x_time_format_scale, virtual: true
    property :index, virtual: true
    property :show_AT_value, virtual: true
    property :show_AT_colour, virtual: true
    property :show_exer_value, virtual: true
    property :show_exer_colour, virtual: true
    property :show_vo2max_value, virtual: true
    property :show_vo2max_colour, virtual: true

    validation  with: { form: true } do

    end
  end
end
