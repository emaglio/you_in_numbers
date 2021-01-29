require 'reform/form/dry'

module Subject::Contract
  class EditHeightWeight < Reform::Form
    feature Reform::Form::Dry

    property :height
    property :weight

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def greater_than_zero?(value)
          value.to_i > 0
        end
      end

      required(:height).filled(:greater_than_zero?)
      required(:weight).filled(:greater_than_zero?)
    end
  end
end
