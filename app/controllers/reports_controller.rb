class ReportsController < ApplicationController

  def welcome
    render RailsBootstrap::Cell::Welcome, nil, layout_type: "welcome"
  end

  def index
    run Report::Index

    render Report::Cell::Index, result["model"]
  end

  def new
    run Report::New

    render Report::Cell::New, result["contract.default"]
  end

  def create
    run Report::Create do |result|
      return redirect_to "/reports/#{result["model"].id}"
    end

    render Report::Cell::New, result["contract.default"]
  end

  def show
    run Report::Show

    render Report::Cell::Show, result["model"]
  end

  def destroy
    run Report::Delete do
      flash[:success] = "Report deleted!"
      return redirect_to "/reports"
    end
  end

  def generate_image
    raise params.inspect
    run Report::GenerateImage
  end

  def generate_pdf
    run Report::GeneratePdf do |result|
      flash[:success] = "Report generated successfully!"
      render Report::Cell::Show, result["model"]
    end

    flash[:danger] = "Something went wrong...please try again!"
    render Report::Cell::Show, result["model"]
  end

  def update_template
    run Report::UpdateTemplate do |result|
      flash[:success] = "Report template updated!"
      return redirect_to "/reports/#{result["model"].id}"
    end

    flash[:danger] = "Report not found"
    return redirect_to reports_path
  end

end
