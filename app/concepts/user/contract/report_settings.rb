require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class ReportSettings < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :report_settings, filed: :hash do
        property :params_list
        property :ergo_params_list
        property :report_path
        property :training_zones_levels
      end
    end

    # used for the training zones
    property :fat_burning_1, virtual: true
    property :fat_burning_2, virtual: true
    property :endurance_1, virtual: true
    property :endurance_2, virtual: true
    property :at_1, virtual: true
    property :at_2, virtual: true
    property :vo2max_1, virtual: true
    property :vo2max_2, virtual: true

    # user for the ergometer params
    property :load_1, virtual: true
    property :load_1_um, virtual: true
    property :load_2, virtual: true
    property :load_2_um, virtual: true


    unnest :report_settings, from: :content
    unnest :training_zones_levels, from: :report_settings
    unnest :params_list, from: :report_settings
    unnest :ergo_params_list, from: :report_settings
    unnest :report_path, from: :report_settings

    validation  with: { form: true } do

      required(:fat_burning_2).filled
      required(:endurance_1).filled
      required(:endurance_2).filled
      required(:at_1).filled
      required(:at_2).filled
      required(:vo2max_1).filled

      required(:params_list).filled
      required(:load_1).filled
      required(:load_1_um).filled
      required(:load_2).filled
      required(:load_2_um).filled

      rule(zones_ok?: [:fat_burning_1, :fat_burning_2]) do |fat_burning_1, fat_burning_2|
        fat_burning_2.gt?(value(:fat_burning_1))
      end

      rule(zones_ok2?: [:fat_burning_2, :endurance_1]) do |fat_burning_2, endurance_1|
        endurance_1.gt?(value(:fat_burning_2))
      end

      rule(zones_ok3?: [:endurance_1, :endurance_2]) do |endurance_1, endurance_2|
        endurance_2.gt?(value(:endurance_1))
      end

      rule(zones_ok4?: [:endurance_2, :at_1]) do |endurance_2, at_1|
        at_1.gt?(value(:endurance_2))
      end

      rule(zones_ok5?: [:at_1, :at_2]) do |at_1, at_2|
        at_2.gt?(value(:at_1))
      end

      rule(zones_ok6?: [:at_2, :vo2max_1]) do |at_2, vo2max_1|
        vo2max_1.gt?(value(:at_2))
      end
    end
  end
end
