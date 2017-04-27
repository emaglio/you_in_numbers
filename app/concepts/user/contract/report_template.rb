require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class ReportTemplate < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :template
    end

    property :type, virtual: true
    property :y1, virtual: true
    property :y2, virtual: true
    property :y3, virtual: true
    property :x, virtual: true
    property :show_AT, virtual: true
    property :show_exer, virtual: true
    property :show_vo2max, virtual: true

    unnest :template, from: :content

    validation  with: { form: true } do

    end
  end
end
