require 'reform/form/dry'

module Report::Contract
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
      end

      def email?
        ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
      end

      # TODO: add limit in lenght
      required(:name).filled
      required(:address_1).filled
      required(:city).filled
      required(:postcode).filled
    end
  end
end
