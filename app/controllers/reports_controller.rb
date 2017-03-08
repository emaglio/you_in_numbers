class ReportsController < ApplicationController

  def welcome
    render RailsBootstrap::Cell::Welcome, nil
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


end