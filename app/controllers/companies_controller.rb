class CompaniesController < ApplicationController

  def new
    run Company::New

    render Company::Cell::New, result["contract.default"]
  end

  def create
    run Company::Create do |result|
      flash[:notice] = "Company details updated!"
      return redirect_to "/users/#{result["model"].user_id}"
    end

    render Company::Cell::New, result["contract.default"]
  end

  def show
    run Company::Show

    render Company::Cell::Show, result["model"]
  end

  def edit
    run Company::Edit

    render Company::Cell::Edit, result["contract.default"]
  end

  def update
    run Company::Update do |result|
      flash[:notice] = "Company details updated!"
      return redirect_to "/users/#{result["model"].user_id}"
    end

    render Company::Cell::Edit, result["contract.default"]
  end

  def destroy
    run Company::Delete do |result|
      flash[:notice] = "Company deleted!"
      return  redirect_to "/users/#{current_user.id}"
    end
  end

end # class CompaniesController
