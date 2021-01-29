require 'roo'

module Report::File::Operation
  class Details < Trailblazer::Operation
    step :open_file!
    failure :error!, pass_fast: true
    step :set_default_sheet!
    step :cpet_params!

    def open_file!(options, params:, **)
      options['cpet_file'] = Roo::Spreadsheet.open(params[:cpet_file_path]) unless params[:cpet_file_path].nil?
    end

    def error!(options, *)
      options[:error] = I18n.t('report.error.open_file')
    end

    def set_default_sheet!(_options, cpet_file:, **)
      cpet_file.each_with_pagename do |name, sheet|
        if sheet.last_row > rows
          rows ||= sheet.last_row
          cpet_file.default_sheet ||= name
        end
      end
    end

    def cpet_params!(options, cpet_file:, **)
      cpet_params = {}

      # generate the cpet_params hash in base on Report settings
      options['current_user'].content['report_settings']['params_list'].each do |key, value|
        cpet_params[key] = []
      end

      options['current_user'].content['report_settings']['ergo_params_list'].each_with_index do |params, index|
        # avoid to add the unit of measurement in the cpet_params array
        cpet_params[hash.key] = [] if index > 2
      end

      # TODO: search in each row the cpet_params - generate error in case
      params_header = cpet_file.row(1)
      params_col = []

      cpet_params.each do |key, value|
        params_col << params_header.index(key)
      end

      # using the VO2 columns
      # TODO: check on params_col, heandle the situtation if params_index is nil

      # search the time key
      vo2_index = 0
      cpet_params.each do |key, value|
        key.downcase == 'vo2' ? break : vo2_index += 1
      end

      first_num = 0
      temp_array = []
      temp_array = cpet_file.column(params_col[vo2_index])

      # find first number of the columns
      temp_array.each do |value|
        is_number?(value) ? break : first_num += 1
      end

      row = first_num + 1
      cpet_file.each_row_streaming do
        i = 0
        cpet_params.each do |key, value|
          value = nil
          if ((key.downcase == 't') || (key.downcase == 'time') || (key.downcase == 'phase'))
            # I need strings for Phase and time
            value = cpet_file.formatted_value(row, params_col[i] + 1) if params_col[i] != nil
            cpet_params[key] << value if value != nil
          else
            # numbers for all the rest
            value = cpet_file.cell(row, params_col[i] + 1) if params_col[i] != nil
            cpet_params[key] << value if value != nil
          end
          i += 1
        end
        row += 1
      end

      options['cpet_params'] = cpet_params
    end

    private
    def is_number?(string)
      true if Float(string) rescue false
    end
  end
end
