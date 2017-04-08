class CompaniesController < ApplicationController

  def new
    run Company::New

    render Company::Cell::New, result["contract.default"]
  end

end # class CompaniesController
