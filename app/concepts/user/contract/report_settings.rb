require 'reform/form/dry'
require 'disposable/twin/property/hash'
require 'disposable/twin/property/unnest'

module User::Contract
  class ReportSettings < Reform::Form
    feature Reform::Form::Dry
    include Disposable::Twin::Property::Hash

    property :content, field: :hash do
      property :params_list
      property :report_path
    end

    unnest :params_list, from: :content
    unnest :report_path, from: :content
  end
end
