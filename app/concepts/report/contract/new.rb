require 'reform/form/dry'
require 'pathname'

module Report::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :title
    property :user_id
    property :cpet_file_path, virtual: true
    property :rmr_file_path, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def file_exists?
          form.cpet_file_path.tempfile.size > 0
        end
      end

      required(:title).filled
      required(:user_id).filled
      required(:cpet_file_path).maybe(:file_exists?)
    end
  end
end
