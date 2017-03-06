class ReportsController < ApplicationController

  def welcome
    render RailsBootstrap::Cell::Welcome, nil
  end

  def new
    run Report::New

    render Report::Cell::New, result["contract.default"]
  end

  def create
  end


end