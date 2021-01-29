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
    property :website
    property :user_id
    property :logo, virtual: true

    extend Paperdragon::Model::Writer
    processable_writer :logo

    property :logo_meta_data

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def email?
          return true if form.email == ''
          !/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
        end

        def number?
          return true if form.postcode == ''
          true if Float(form.postcode) rescue false
        end
      end

      # TODO: add limit in lenght maybe
      # TODO: add file validations

      required(:user_id).filled
      required(:name).filled
      required(:email).maybe(:email?)
      required(:postcode).maybe(:number?)
    end
  end
end
