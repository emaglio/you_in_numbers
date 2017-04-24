module User::Cell

  class GetReportSettings < New

    def collection_array
      array = (0..100).map {|i| [i,i] }
      return array
    end

    def content
      options[:context][:current_user].content
    end

    def training_zones
      content != nil ? content["training_zones_settings"] : []
    end

    def ergo_params
      content != nil ? content["ergo_params_list"] : []
    end

    def params
      content != nil ? (content["params_list"].map {|str| "#{str}"}.join(',')) : ""
    end

  end # class GetReportSettings

end # module User::Cell
