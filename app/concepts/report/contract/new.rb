require 'reform/form/dry'
require 'pathname'

module Report::Contract 
  class New < Reform::Form 
    feature Reform::Form::Dry

    property :title
    property :cpet_file_path, virtual: true
    property :rmr_file_path, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'
      end

      required(:title).filled
    end
  end
end