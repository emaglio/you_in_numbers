require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module Subject::Contract
  class New < Reform::Form
    feature Reform::Form::Dry

    property :user_id
    property :email
    property :firstname
    property :lastname
    property :gender
    property :height
    property :weight
    property :phone
    property :dob
    property :content

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def unique_email?
          Subject.where("email = ?", form.email).size == 0
        end

        def email?
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
        end

        def unique_subject?
          (Subject.where("firstname = ?", form.firstname).size == 0) or (Subject.where("lastname = ?", form.lastname).size == 0) or (Subject.where("dob = ?", form.dob).size == 0)
        end
      end

      required(:email).maybe(:email?)
      required(:user_id).filled
      required(:firstname).filled
      required(:lastname).filled
      required(:gender).filled
      required(:dob).filled
      required(:height).filled(gt?: 0)
      required(:weight).filled(gt?: 0)

      validate(unique_email?: :email) do
        unique_email?
      end

      validate(unique_subject?: :firstname) do
        unique_subject?
      end
    end

  end
end
