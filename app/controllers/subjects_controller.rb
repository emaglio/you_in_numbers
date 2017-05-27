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

  end

  def update

  end

  def delete

  end

  def edit_height_weight

  end
end
