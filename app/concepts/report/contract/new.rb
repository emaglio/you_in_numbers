require 'reform/form/dry'

module Report::Contract 
  class New < Reform::Form 
    feature Reform::Form::Dry

    property :title
    property :cpet_file_path, virtual: true
    property :rmr_file_path, virtual: true

    validation do
      configure do
        config.messages_file = 'config/error_messages.yml'
      end
    end
  end
end