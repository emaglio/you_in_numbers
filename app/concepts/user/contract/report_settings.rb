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
        property :training_zones_settings
        property :units_of_measurement
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

    #user for unit_of_measurment
    property :um_height, virtual: true
    property :um_weight, virtual: true

    unnest :report_settings, from: :content
    unnest :training_zones_settings, from: :report_settings
    unnest :params_list, from: :report_settings
    unnest :ergo_params_list, from: :report_settings
    unnest :report_path, from: :report_settings
    unnest :units_of_measurement, from: :report_settings

    validation  with: { form: true } do

      configure do
        config.messages_file = 'config/error_messages.yml'

        def fat_burning_ok?
          form.fat_burning_2.to_i > form.fat_burning_1.to_i
        end

        def endurance_ok?
          return false if form.endurance_1.to_i < form.fat_burning_2.to_i
          form.endurance_2.to_i > form.endurance_1.to_i
        end

        def at_ok?
          return false if form.at_1.to_i < form.endurance_2.to_i
          form.at_2.to_i > form.at_1.to_i
        end

        def vo2max_ok?
          return false if form.vo2max_1.to_i < form.at_2.to_i
          form.vo2max_1.to_i < 100
        end
      end

      required(:fat_burning_2).filled(:fat_burning_ok?)
      required(:endurance_1).filled(:endurance_ok?)
      required(:endurance_2).filled(:endurance_ok?)
      required(:at_1).filled(:at_ok?)
      required(:at_2).filled(:at_ok?)
      required(:vo2max_1).filled(:vo2max_ok?)

      required(:params_list).filled
      required(:load_1).filled
      required(:load_1_um).filled
      required(:load_2).filled
      required(:load_2_um).filled

      required(:um_height).filled
      required(:um_weight).filled
    end
  end
end
