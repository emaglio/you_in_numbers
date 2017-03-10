require 'roo'

class Report::GetCpetData < Trailblazer::Operation
  step :open_file!
  step :set_default_sheet!
  step :cpet_params!

  def open_file!(options, params:, **)
    options["cpet_file"] = Roo::Spreadsheet.open(params[:cpet_file_path]) if params[:cpet_file_path] != nil
  end

  def set_default_sheet!(options, cpet_file:, **)
    rows = 0
    sheet_name = ""
    cpet_file.each_with_pagename do |name, sheet|
      if sheet.last_row > rows 
        rows = sheet.last_row 
        sheet_name = name
      end
    end

    cpet_file.default_sheet = sheet_name
  end

  def cpet_params!(options, cpet_file:, **)
    cpet_params = { "t" => [], "time" => [], "Rf" => [], "VE" => [], "VO2" => [], "VCO2" => [], 
                    "RQ" => [], "VE/VO2" => [], "HR" => [], "VO2/Kg" => [], "FAT%" => [], "CHO%" => [],
                    "Power" => [], "Revolution" => [], "Phase" => []
                  }

    params_header = cpet_file.row(1)
    params_col = []

    # TODO: needs to find the params with different format ex: VO2, Vo2, vo2
    cpet_params.each do |key, value|
      params_col << params_header.index(key)
    end

    # using the VO2 columns
    # TODO: check on params_col, heandle the situtation if params_index is nil
    first_num = 0
    temp_array = []
    temp_array = cpet_file.column(params_col[4])

    # find first number of the columns
    temp_array.each do |value|
      is_number?(value) ? break : first_num += 1
    end

    row = first_num + 1
    cpet_file.each_row_streaming do
      i = 0
      cpet_params.each do |key, value|
        value = nil
        if (key == "t" or key == "time" or key == "Phase") 
          # I need strings for Phase and time
          value = cpet_file.formatted_value(row, params_col[i]+1) if params_col[i] != nil
          cpet_params[key] << value if value != nil
        else
          # numbers for all the rest
          value = cpet_file.cell(row, params_col[i]+1) if params_col[i] != nil
          cpet_params[key] << value if value != nil
        end
        i += 1
      end
      row += 1
    end

    options["cpet_params"] = cpet_params
  end


private
  def is_number?(string)
    true if Float(string) rescue false
  end
  
end