require 'reform/form/dry'
require 'date'

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

        def greater_than_zero?(value)
          value.to_i > 0
        end

        def greater_than_10_years?
          return false if DateTime.parse(form.dob) > DateTime.now
          (((DateTime.now - DateTime.parse(form.dob))/365).round) > 5
        end
      end

      required(:email).maybe
      required(:user_id).filled
      required(:firstname).filled
      required(:lastname).filled
      required(:gender).filled
      required(:dob).filled(:greater_than_10_years?)
      required(:height).filled(:greater_than_zero?)
      required(:weight).filled(:greater_than_zero?)

      validate(email?: :email) do
        email?
      end

      validate(unique_email?: :email) do
        unique_email?
      end

      validate(unique_subject?: :firstname) do
        unique_subject?
      end
    end

  end
end
