class SubjectsController < ApplicationController
  include TrbV21

  def new
    run_v21(Subject::Operation::Create::Present)

    render Subject::Cell::New, result['contract.default']
  end

  def create
    run_v21(Subject::Operation::Create) do |result|
      flash[:success] = 'Subject created!'
      return redirect_to new_report_path(nil, subject_id: result['model'].id) if result['new_report']
      return redirect_to '/subjects'
    end

    render Subject::Cell::New, result['contract.default']
  end

  def index
    run_v21(Subject::Operation::Index)

    render Subject::Cell::Index, result['model']
  end

  def get_reports
    run_v21(Subject::Operation::GetReports)

    render Subject::Cell::GetReports, result['reports'], layout_type: nil
  end

  def show
    run_v21(Subject::Operation::Show)

    render Subject::Cell::Show, result['model']
  end

  def edit
    run_v21(Subject::Operation::Update::Present)

    render Subject::Cell::Edit, result['contract.default']
  end

  def update
    run_v21(Subject::Operation::Update) do |result|
      flash[:success] = 'Subject details updated'
      return redirect_to new_report_path(nil, subject_id: result['model'].id) if result['new_report']
      return redirect_to "/subjects/#{result['model'].id}"
    end

    render Subject::Cell::Edit, result['contract.default']
  end

  def destroy
    run_v21(Subject::Operation::Delete) do |result|
      flash[:success] = 'Subject deleted'
      return redirect_to '/subjects'
    end
  end

  def edit_height_weight
    run_v21(Subject::Operation::EditHeightWeight) do |result|
      flash[:success] = 'Subejct details updated!'
      return redirect_to new_report_path(nil, subject_id: result['model'].id)
    end

    flash[:danger] = 'Height and weight must be greater than zero!'
    return redirect_to edit_subject_path(result['model'].id, new_report: true)
  end
end
