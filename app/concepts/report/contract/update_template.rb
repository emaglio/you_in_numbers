require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module Report::Contract
  class UpdateTemplate < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :template
    end

    property :template, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'
      end

      required(:template).filled
    end

    unnest :template, from: :content
  end
end
