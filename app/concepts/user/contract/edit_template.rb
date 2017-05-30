require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class EditTemplate < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :report_template, field: :hash do
        property :custom
      end
    end

    property :move_up, virtual: true
    property :move_down, virtual: true
    property :edit_chart, virtual: true
    property :delete, virtual: true
    property :type, virtual: true
    property :index, virtual: true

    validation  with: { form: true } do

      configure do
        config.messages_file = 'config/error_messages.yml'
        def check_index?(value)
          return false if value == ""
          (value).to_i >= 0
        end

      end

      required(:move_up).maybe(:check_index?)
      required(:move_down).maybe(:check_index?)
      required(:edit_chart).maybe(:check_index?)
      required(:delete).maybe(:check_index?)
      required(:type).maybe(:str?)
      required(:index).maybe(:check_index?)
    end
  end
end
