class SubjectsController < ApplicationController

  def new
    run Subject::New

    render Subject::Cell::New, result["contract.default"]
  end

  def create
    run Subject::Create do |result|
      flash[:success] = "Subject created!"
      return redirect_to new_report_path(nil, subject_id: result["model"].id) if result["new_report"]
      return redirect_to "/subjects"
    end

    render Subject::Cell::New, result["contract.default"]
  end

  def index
    run Subject::Index

    render Subject::Cell::Index, result["model"]
  end

  def get_reports
    run Subject::GetReports

    render Subject::Cell::GetReports, result["reports"], layout_type: nil
  end

  def show
    run Subject::Show

    render Subject::Cell::Show, result["model"]
  end

  def edit
    run Subject::Edit

    render Subject::Cell::Edit, result["contract.default"]
  end

  def update
    run Subject::Update do |result|
      flash[:success] = "Subject details updated"
      return redirect_to new_report_path(nil, subject_id: result["model"].id) if result["new_report"]
      return redirect_to "/subjects/#{result["model"].id}"
    end

    render Subject::Cell::Edit, result["contract.default"]
  end

  def delete
    run Subject::Delete do |result|
      flash[:success] = "Subject deleted successfully"
      return redirect_to "subjects"
    end
  end

  def edit_height_weight
    run Subject::EditHeightWeight do |result|
      flash[:success] = "Subejct details updated!"
      return redirect_to new_report_path(nil, subject_id: result["model"].id)
    end

    flash[:danger] = "Height and weight must be greater than zero!"
    return redirect_to edit_subject_path(result["model"].id, new_report: true)
  end
end
