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

  def generate_pdf
    file = File.open("#{Rails.root}/public/temp_files/image.jpeg", "wb")
    file.write(params[:image].read)

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
