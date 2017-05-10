require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class EditTemplate < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :report_template, field: :hash do
        property :custom, virtual: true
      end
    end

    unnest :report_template, from: :content
    unnest :custom, from: :report_template

    property :move_up, virtual: true
    property :move_down, virtual: true
    property :edit_chart, virtual: true
    property :delete, virtual: true
    property :type, virtual: true
    property :index, virtual: true

    validation  with: { form: true } do

      configure do
        config.messages_file = 'config/error_messages.yml'
        def grater_than_zero?(value)
          (value).to_i >= 0
        end

      end

      required(:move_up).maybe(:grater_than_zero?)
      required(:move_down).maybe(:grater_than_zero?)
      required(:edit_chart).maybe(:grater_than_zero?)
      required(:delete).maybe(:grater_than_zero?)
      required(:type).maybe(:str?)
      required(:index).maybe(:grater_than_zero?)
    end
  end
end
