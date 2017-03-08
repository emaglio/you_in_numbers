require 'test_helper'
require 'roo'

# class ReportTest < MiniTest::Spec



#   cpet_path = './app/assets/files/cpet.xlsx'

#   cpet_file = Roo::Spreadsheet.open(cpet_path)

#   puts get_data_sheet(cpet_file)
  
# end

module MyReport

  class Op
    
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
      params = {"t" => 0, "Rf" => 0, "VO2" => 0, "VCO2" => 0}

      params_header = file.row(1)

      params.each do |key, value|
        params[key] = params_header.index(key)
      end

      puts params.inspect


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