class ReportsController < ApplicationController

  def welcome
    render RailsBootstrap::Cell::Welcome, nil
  end


end