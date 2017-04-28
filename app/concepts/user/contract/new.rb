require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class New < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :email
    property :firstname
    property :lastname
    property :gender
    property :phone
    property :age
    property :block
    property :password, virtual: true
    property :confirm_password, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def unique_email?
          User.where("email = ?", form.email).size == 0
        end

        def email?
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
        end

        def must_be_equal?
          return form.password == form.confirm_password
        end
      end

      required(:email).filled(:email?)
      required(:password).filled
      required(:confirm_password).filled


      validate(unique_email?: :email) do
        unique_email?
      end

      validate(must_be_equal?: :confirm_password) do
        must_be_equal?
      end
    end

    # to create default report settings
    property :content, field: :hash do

      property :report_settings, filed: :hash do
        property :params_list
        property :ergo_params_list
        property :report_path
        property :training_zones_levels
      end

      property :report_template, field: :jash do
        property :default
        property :templates
      end
    end

    unnest :report_settings, from: :content
    unnest :training_zones_levels, from: :report_settings
    unnest :params_list, from: :report_settings
    unnest :ergo_params_list, from: :report_settings
    unnest :report_path, from: :report_settings

    # to create default template

    unnest :report_template, from: :content
    unnest :default, from: :report_template
    unnest :templates, from: :report_template

  end
end
