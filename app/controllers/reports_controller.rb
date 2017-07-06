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
    html = cell(Report::Cell::Show, Report.find(params[:id]), current_user: tyrant.current_user).()
    kit = PDFKit.new(html)
    kit.stylesheets << File.join(File.dirname(__dir__), "../vendor", "assets", "bootstrap", "css", "bootstrap.css")
    pdf = kit.to_pdf
    file = kit.to_file(File.join(File.dirname(__FILE__), 'some.pdf'))

    # run Report::GenerateImage
    #TODO: run js stuff to show a message or something
  end

  def generate_pdf
    run Report::GeneratePdf do |result|
      flash[:success] = "Report generated successfully!"
      return redirect_to "/reports"
    end

    if result["company"] == nil
      flash[:danger] = "Create a company and try to generate the report again!"
      return redirect_to "/companies/new"
    end

    flash[:danger] = "An error occured -> " + result["error"]
    redirect_to "/reports/#{result["model"].id}"
  end

  def update_template
    run Report::UpdateTemplate do |result|
      flash[:success] = "Report template updated!"
      return redirect_to "/reports/#{result["model"].id}"
    end

    result["not_found"] ? flash[:danger] = "Report not found" : flash[:danger] = "Something went wrong, please try again!"
    return redirect_to reports_path
  end

end
