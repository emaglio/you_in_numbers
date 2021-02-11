class CompaniesController < ApplicationController
  include TrbV21

  def new
    run_v21(Company::Operation::Create::Present)

    render Company::Cell::New, result['contract.default']
  end

  def create
    run_v21(Company::Operation::Create) do |result|
      flash[:success] = 'Company details updated!'
      return redirect_to "/users/#{result['model'].user_id}"
    end

    render Company::Cell::New, result['contract.default']
  end

  def show
    run_v21(Company::Operation::Show)

    render Company::Cell::Show, result['model']
  end

  def edit
    run_v21(Company::Operation::Update::Present)

    render Company::Cell::Edit, result['contract.default']
  end

  def update
    run_v21(Company::Operation::Update) do |result|
      flash[:success] = 'Company details updated!'
      return redirect_to "/users/#{result['model'].user_id}"
    end

    render Company::Cell::Edit, result['contract.default']
  end

  def destroy
    run_v21(Company::Operation::Delete) do |result|
      flash[:success] = 'Company deleted!'
      return redirect_to "/users/#{current_user.id}"
    end
  end

  def delete_logo
    run_v21(Company::Operation::DeleteLogo) do
      flash[:success] = 'Company Logo deleted!'
      return redirect_to "/users/#{current_user.id}"
    end
  end
end # class CompaniesController
