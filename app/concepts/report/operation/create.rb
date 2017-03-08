require_dependency 'report/operation/new'
require 'roo'

class Report::Create < Trailblazer::Operation
  step Nested(Report::New)
  step Contract::Validate()
  step :open_file
  # step Nested(Report::GetData)
  step Contract::Persist()

  def open_file(options, params:, **)
    options["cpet_file"] = Roo::Spreadsheet.open(params[:cpet_file_path]) if params[:cpet_file_path] != nil
    options["rmr_file"] = Roo::Spreadsheet.open(params[:rmr_file_path]) if params[:rmr_file_path] != nil

    return true
  end
end