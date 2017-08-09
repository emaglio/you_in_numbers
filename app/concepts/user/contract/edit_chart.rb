require 'reform/form/dry'

module User::Contract
  class EditChart < Reform::Form
    feature Reform::Form::Dry

    property :edit_chart, virtual: true #used as index
    property :title, virtual: true
    property :y1_select, virtual: true
    property :y1_colour, virtual: true
    property :y1_scale, virtual: true
    property :y2_select, virtual: true
    property :y2_colour, virtual: true
    property :y2_scale, virtual: true
    property :y3_select, virtual: true
    property :y3_colour, virtual: true
    property :y3_scale, virtual: true
    property :x, virtual: true
    property :x_time, virtual: true
    property :x_format, virtual: true
    property :vo2max_show, virtual: true
    property :vo2max_colour, virtual: true
    property :exer_show, virtual: true
    property :exer_colour, virtual: true
    property :at_show, virtual: true
    property :at_colour, virtual: true
    property :only_exer, virtual: true

    validation  with: { form: true } do
      configure do
        config.messages_file = 'config/error_messages.yml'

        def at_least_one_y_scale?
          form.y1_scale == "1" or form.y2_scale == "1" or form.y3_scale == "1"
        end
      end

      required(:y1_select).filled

      validate(y1_scale: :y1_select) do
        at_least_one_y_scale?
      end

      validate(y2_scale: :y1_select) do
        at_least_one_y_scale?
      end

      validate(y3_scale: :y1_select) do
        at_least_one_y_scale?
      end

    end
  end
end
