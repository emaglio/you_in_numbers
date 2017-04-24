require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class ReportSettings < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :params_list
      property :report_path
      property :training_zones_levels
    end

    property :fat_burning_1, virtual: true
    property :fat_burning_2, virtual: true
    property :endurance_1, virtual: true
    property :endurance_2, virtual: true
    property :at_1, virtual: true
    property :at_2, virtual: true
    property :vo2max_1, virtual: true
    property :vo2max_2, virtual: true

    unnest :training_zones_levels, from: :content
    unnest :params_list, from: :content
    unnest :report_path, from: :content
  end
end
