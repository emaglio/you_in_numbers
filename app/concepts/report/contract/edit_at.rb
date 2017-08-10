module Report::Contract
  class EditAt < Reform::Form
    property :at_position, virtual: true
  end
end
