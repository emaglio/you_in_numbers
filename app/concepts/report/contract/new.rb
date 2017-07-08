require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'
require 'pathname'

module Report::Contract
  class New < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :title
    property :user_id
    property :subject_id
    property :cpet_params
    property :cpet_results
    property :rmr_params
    property :rmr_results
    property :cpet_file_path, virtual: true
    property :rmr_file_path, virtual: true

    property :template, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def file_exists?
          # TODO: fix this
          # File.exists?(form.cpet_file_path.path())
          true
        end

        def at_least_one_file?
          (form.cpet_file_path != nil) or (form.rmr_file_path != nil)
        end
      end

      required(:title).filled
      required(:user_id).filled
      required(:subject_id).filled
      required(:template).filled
      required(:cpet_file_path).maybe(:file_exists?)
      required(:rmr_file_path).maybe(:file_exists?)

      validate(at_least_one_file?: :cpet_file_path) do
        at_least_one_file?
      end

      validate(at_least_one_file?: :rmr_file_path) do
        at_least_one_file?
      end
    end

    property :content, field: :hash do
      property :template
      property :subject, field: :hash do
        property :height
        property :weight
      end
    end

    unnest :subject, from: :content
    unnest :height, from: :subject
    unnest :weight, from: :subject
    unnest :template, from: :content

  end
end
