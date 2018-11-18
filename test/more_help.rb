class GetData

  def number?(string)
    true if Float(string)
  rescue StandardError
    false
  end

  # find the bigger sheet I suppose the data are saved (maybe use always the first sheet)
  # and set it as defualt one
  def default_sheet(file)
    rows = 0
    sheet_name = ""
    file.each_with_pagename do |name, sheet|
      if sheet.last_row > rows
        rows = sheet.last_row
        sheet_name = name
      end
    end

    file.default_sheet = sheet_name
  end

  # find list of column index for all the parameters
  def cpet_params(file)
    cpet_params = { "t" => [], "time" => [], "Rf" => [], "VE" => [], "VO2" => [], "VCO2" => [],
                    "RQ" => [], "VE/VO2" => [], "HR" => [], "VO2/Kg" => [], "FAT%" => [], "CHO%" => [],
                    "Power" => [], "Revolution" => [], "Phase" => [] }

    params_header = file.row(1)
    params_col = []

    # TODO: needs to find the params with different format ex: VO2, Vo2, vo2
    cpet_params.each do |key, _value|
      params_col << params_header.index(key)
    end

    # using the VO2 columns
    # TODO: check on params_col, heandle the situtation if params_index is nil
    first_num = 0
    temp_array = file.column(params_col[4])

    # find first number of the columns
    temp_array.each do |value|
      number?(value) ? break : first_num += 1
    end

    row = first_num + 1
    file.each_row_streaming do
      i = 0
      cpet_params.each do |key, value|
        value = nil
        if (key == "t") || (key == "time") || (key == "Phase")
          # I need strings for Phase and time
          value = file.formatted_value(row, params_col[i] + 1) unless params_col[i].nil?
        else
          # numbers for all the rest
          value = file.cell(row, params_col[i] + 1) unless params_col[i].nil?
        end
        cpet_params[key] << value unless value.nil?
        i += 1
      end
      row += 1
    end

    return cpet_params
  end
end
