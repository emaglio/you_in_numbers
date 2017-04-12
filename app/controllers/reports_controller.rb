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


end
