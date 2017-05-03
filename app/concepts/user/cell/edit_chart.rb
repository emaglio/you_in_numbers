module User::Cell

  class EditChart < Trailblazer::Cell
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::CsrfHelper

    def params
      array = []
      params_list = model.content["report_settings"]["params_list"]
      ergo_params_list = model.content["report_settings"]["ergo_params_list"]

      array << "none"

      params_list.each do |value|
        array << value
      end

      ergo_params_list.each do |value|
        array << value
      end

      return array
    end

  end #class Chart

end # module User::Cell
