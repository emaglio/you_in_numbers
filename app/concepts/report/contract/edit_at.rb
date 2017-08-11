require 'reform/form/dry'

module Report::Contract
  class EditAt < Reform::Form
    feature Reform::Form::Dry

    property :at_position, virtual: true

    validation do
      required(:at_position).filled
    end

  end
end
