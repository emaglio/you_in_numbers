module User::Cell
  class GetReportSettings < New
    def collection_array
      array = (0..100).map { |i| [i, i] }
      return array
    end

    def report_settings
      options[:context][:current_user].content['report_settings']
    end

    def training_zones
      report_settings != nil ? report_settings['training_zones_settings'] : []
    end

    def ergo_params
      report_settings != nil ? report_settings['ergo_params_list'] : []
    end

    def params
      report_settings != nil ? (report_settings['params_list'].map { |str| "#{str}" }.join(',')) : ''
    end

    def um_height
      report_settings['units_of_measurement']['height']
    end

    def um_weight
      report_settings['units_of_measurement']['weight']
    end
  end # class GetReportSettings
end # module User::Cell
