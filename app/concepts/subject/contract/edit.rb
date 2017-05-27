require 'reform/form/dry'
require 'date'

module Subject::Contract
  class Edit < Reform::Form
    feature Reform::Form::Dry

    property :id
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
          return true if Subject.find(form.id).email == form.email
          return true if form.email == ""
          Subject.where("email = ?", form.email).size == 0
        end

        def email?
          return true if form.email == ""
          ! /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
        end

        def unique_subject?
          return true if ((Subject.find(form.id).email == form.email) and (Subject.find(form.id).firstname == form.firstname) and (Subject.find(form.id).lastname == form.lastname))
          Subject.where("firstname like ? AND lastname like ? AND dob like ?", form.firstname, form.lastname, DateTime.parse(form.dob)).size == 0
        end

        def greater_than_zero?(value)
          value.to_i > 0
        end

        def check_age?
          return false if DateTime.parse(form.dob) > DateTime.now
          dob = (((DateTime.now - DateTime.parse(form.dob))/365).round)
          dob > 5 and dob < 120
        end
      end

      required(:email).maybe(:email?)
      required(:firstname).filled
      required(:lastname).filled
      required(:gender).filled
      required(:dob).filled(:check_age?)
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
