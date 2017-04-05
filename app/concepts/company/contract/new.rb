require 'reform/form/dry'

module Company::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :name
    property :address_1
    property :address_2
    property :city
    property :postcode
    property :country
    property :phone
    property :email

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def email?
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
        end

      end

      # TODO: add limit in lenght maybe
      required(:name).filled
      required(:email).maybe(:email?)
    end
  end
end
