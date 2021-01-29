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
    property :new_report, virtual: true # to redirect to Report::New if true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def unique_email?
          return true if form.email == ''

          Subject.where('email = ?', form.email).size == 0
        end

        def email?
          return true if form.email == ''

          !/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match(form.email).nil?
        end

        def unique_subject? # TODO: call this only if form.dob is != nil
          Subject.where(
            'firstname like ? AND lastname like ? AND dob like ?',
            form.firstname, form.lastname, DateTime.parse(form.dob)
          ).size == 0
        end

        def greater_than_zero?(value)
          value.to_i > 0
        end

        def check_age?
          return false if DateTime.parse(form.dob) > DateTime.now

          dob = (((DateTime.now - DateTime.parse(form.dob)) / 365).round)
          dob > 5 and dob < 120
        end
      end

      required(:email).maybe(:email?)
      required(:user_id).filled
      required(:firstname).filled
      required(:lastname).filled
      required(:gender).filled
      required(:dob).filled
      required(:height).filled(:greater_than_zero?)
      required(:weight).filled(:greater_than_zero?)

      validate(email?: :email) do
        email?
      end

      validate(check_age?: :dob) do
        check_age?
      end

      validate(unique_subject?: :firstname) do
        unique_subject?
      end
    end
  end
end
