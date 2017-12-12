require 'reform/form/dry'

module Report::Contract
  class EditVO2Max < Reform::Form
    feature Reform::Form::Dry

    property :vo2max_starts, virtual: true
    property :vo2max_ends, virtual: true
    property :vo2max_value, virtual: true

    validation do
      required(:vo2max_starts).filled
      required(:vo2max_ends).filled
      required(:vo2max_value).filled
    end

  end
end
