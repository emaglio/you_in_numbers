class ReportsController < ApplicationController
  def welcome
    render RailsBootstrap::Cell::Welcome, nil, layout_type: 'welcome'
  end

  def index
    run(Report::Operation::Index)

    render Report::Cell::Index, result['model']
  end

  def new
    run(Report::Operation::Create::Present)

    render Report::Cell::New, result['contract.default']
  end

  def create
    run(Report::Operation::Create) do |result|
      flash[:success] = 'Report created'
      return redirect_to "/reports/#{result['model'].id}"
    end

    flash[:alert] = result[:error]
    render Report::Cell::New, result['contract.default']
  end

  def show
    run(Report::Operation::Show)

    if result['not_found']
      flash[:danger] = 'Report not found!'
      return redirect_to '/reports'
    end

    if result['param_not_found'] != nil
      flash[:danger] = "The parameter #{result['param_not_found']} has not been found in the report.\n"\
                       ' Please check the Report Settings and re-create the report!'
      return redirect_to '/reports'
    end

    render Report::Cell::Show, result['model']
  end

  def destroy
    run(Report::Operation::Delete) do
      flash[:success] = 'Report deleted!'
      return redirect_to '/reports'
    end
  end

  def generate_image
    run(Report::Operation::GenerateImage)
    # TODO: run js stuff to show a message or something
  end

  def generate_pdf
    run(Report::Operation::GeneratePdf) do |result|
      flash[:success] = 'Report generated successfully!'
      return redirect_to '/reports'
    end

    if result['company'] == nil
      flash[:danger] = 'Create a company and try to generate the report again!'
      return redirect_to '/companies/new'
    end

    result['error'].nil? ? error = '' : error = result['error']

    flash[:danger] = 'An error occured -> ' + error
    redirect_to "/reports/#{result['model'].id}"
  end

  def update_template
    run(Report::Operation::UpdateTemplate) do |result|
      flash[:success] = 'Report template updated!'
      return redirect_to "/reports/#{result['model'].id}"
    end

    flash[:danger] = if result['not_found']
                       'Report not found'
                     else
                       'Something went wrong, please try again!'
                     end
    return redirect_to reports_path
  end

  def edit_at
    run(Report::Operation::EditAt::Present)

    render Report::Cell::EditAt, result['model']
  end

  def update_at
    run(Report::Operation::EditAt) do |result|
      flash[:success] = 'New Anaerobic Threshold saved!'
      return redirect_to "/reports/#{result['model'].id}"
    end

    render Report::Cell::EditAt, result['model']
  end

  def edit_vo2max
    run(Report::Operation::EditVO2Max::Present)

    render Report::Cell::EditVO2Max, result['model']
  end

  def update_vo2max
    run(Report::Operation::EditVO2Max) do |result|
      flash[:success] = 'VO2 Max saved!'
      return redirect_to "/reports/#{result['model'].id}"
    end

    render Report::Cell::EditVO2Max, result['model']
  end
end
