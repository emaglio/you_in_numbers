require 'test_helper'
require 'roo'

# class ReportTest < MiniTest::Spec



#   cpet_path = './app/assets/files/cpet.xlsx'

#   cpet_file = Roo::Spreadsheet.open(cpet_path)

#   puts get_data_sheet(cpet_file)
  
# end

module MyReport

  class Op
    
    def is_number?(string)
      true if Float(string) rescue false
    end

    # find the bigger sheet I suppose the data are saved (maybe use always the first sheet)
    # and set it as defualt one
    def set_default_sheet(file)
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
    def cpet_params_col(file)
      params = {"t" => [], "time" => [], "Rf" => [], "VE" => [], "VO2" => [], "VCO2" => [], 
                "RQ" => [], "VE/VO2" => [], "HR" => [], "VO2/Kg" => [], "FAT%" => [], "CHO%" => [],
                "Power" => [], "Revolution" => [], "Phase" => []
                }

      params_header = file.row(1)
      params_col = []

      # TODO: needs to find the params with different format ex: VO2, Vo2, vo2
      params.each do |key, value|
        params_col << params_header.index(key)
      end

      # using the VO2 columns
      # TODO: check on params_col, heandle the situtation if params_index is nil
      first_num = 0
      temp_array = []
      temp_array = file.column(params_col[4])

      # find first number of the columns
      temp_array.each do |value|
        is_number?(value) ? break : first_num += 1
      end

      row = first_num + 1
      file.each_row_streaming do
        i = 0
        params.each do |key, value|
          params[key] << file.cell(row, params_col[i]) if params_col[i] != nil
          i += 1
        end
        row += 1
      end


      puts params.inspect
      puts params_col.inspect


    end


  end


  class Test
    Op = Op.new

    cpet_path = './app/assets/files/cpet.xlsx'

    cpet_file = Roo::Spreadsheet.open(cpet_path)

    Op::set_default_sheet(cpet_file)

    Op::cpet_params_col(cpet_file)

  end

end