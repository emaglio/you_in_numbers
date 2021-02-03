require 'roo'
require 'pathname'

class Report::Operation::Create < Trailblazer::Operation
  class GetCpetData < Trailblazer::Operation
    step :open_file!
    step :set_default_sheet!
    step :cpet_params!

    def open_file!(options, params:, **)
      options['cpet_file'] = Roo::Spreadsheet.open(params[:cpet_file_path]) unless params[:cpet_file_path].nil?
    end

    # gets sheet with higer number of rowss
    def set_default_sheet!(_options, cpet_file:, **)
      rows = 0
      sheet_name = ''
      cpet_file.each_with_pagename do |name, sheet|
        if sheet.last_row > rows
          rows = sheet.last_row
          sheet_name = name
        end
      end

      cpet_file.default_sheet = sheet_name
    end

    def cpet_params!(options, cpet_file:, **)
      cpet_params = {}

      # generate the cpet_params hash in base on Report settings
      options['current_user'].content['report_settings']['params_list'].each do |key, _value|
        cpet_params[key] = []
      end

      i = 0
      options['current_user'].content['report_settings']['ergo_params_list'].each do |key, _value|
        # avoid to add the unit of measurement in the cpet_params array
        cpet_params[key] = [] if i.zero? || i == 2
        i += 1
      end

      # TODO: search in each row the cpet_params - generate error in case
      params_header = cpet_file.row(1)
      params_col = []

      cpet_params.each do |key, _value|
        params_col << params_header.index(key)
      end

      # using the VO2 columns
      # TODO: check on params_col, heandle the situtation if params_index is nil

      # search the time key
      vo2_index = 0
      cpet_params.each do |key, _value|
        key.casecmp('vo2').zero? ? break : vo2_index += 1
      end

      first_num = 0
      temp_array = cpet_file.column(params_col[vo2_index]) || []

      # find first number of the columns
      temp_array.each do |value|
        is_number?(value) ? break : first_num += 1
      end

      row = first_num + 1
      cpet_file.each_row_streaming do
        i = 0
        cpet_params.each do |key, value|
          value = nil
          if (key.casecmp('t').zero?) || (key.casecmp('time').zero?) || (key.casecmp('phase').zero?)
            # I need strings for Phase and time
            value = cpet_file.formatted_value(row, params_col[i] + 1) unless params_col[i].nil?
            cpet_params[key] << value unless value.nil?
          else
            # numbers for all the rest
            value = cpet_file.cell(row, params_col[i] + 1) unless params_col[i].nil?
            cpet_params[key] << value unless value.nil?
          end
          i += 1
        end
        row += 1
      end

      options['cpet_params'] = cpet_params
    end

    private

    def is_number?(string)
      true if Float(string)
    rescue
      false
    end
  end
end
