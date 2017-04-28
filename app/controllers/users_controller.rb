class UsersController < ApplicationController

  def show
    run User::Show
    render User::Cell::Show, result["model"]
  end

  def user_settings
    run User::Show
    render User::Cell::UserSettings, result["model"]
  end

  def show_report_settings
    run User::Show
    render User::Cell::ShowReportSettings, result["model"]
  end

  def index
    run User::Index
    render User::Cell::Index, result["model"]
  end

  def create
    run User::Create do |result|
      tyrant.sign_in!(result["model"])
      flash[:success] = "Welcome #{get_name(result["model"])}!"
      return redirect_to "/reports"
    end
    render User::Cell::New, result["contract.default"], layout_type: nil
  end

  def new
    run User::New
    render User::Cell::New, result["contract.default"], layout_type: nil
  end

  def edit
    run User::Edit

    render User::Cell::Edit, result["model"]
  end

  def update
    run User::Update do |result|
      flash[:success] = "New details saved"
      return redirect_to "/users/#{result["model"].id}"
    end

    render User::Cell::Edit, result["model"]
  end

  def destroy
    run User::Delete do
      flash[:danger] = "User deleted"
      return redirect_to "/reports"
    end

    render User::Cell::Edit, result["contract.default"]
  end

  def get_email
    run Tyrant::GetEmail
    render User::Cell::ResetPassword, result["contract.default"], layout_type: nil
  end

  def reset_password
    run Tyrant::ResetPassword do
      flash[:danger] = "Your password has been reset"
      return redirect_to "/sessions/new"
    end

    render Tyrant::Cell::ResetPassword, result["contract.default"]
  end

  def get_new_password
    run Tyrant::GetNewPassword
    render User::Cell::ChangePassword, result["contract.default"]
  end

  def change_password
    run User::ChangePassword do
      flash[:danger] = "The new password has been saved"
      return redirect_to user_path(tyrant.current_user)
    end

    render User::Cell::ChangePassword, result["contract.default"]
  end

  def block
    run User::Block do |result|
      if result["model"]["block"] == true
        flash[:danger] = "#{get_name(result["model"])} has been blocked"
      else
        flash[:danger] = "#{get_name(result["model"])} has been un-blocked"
      end
      redirect_to users_path
    end
  end

  def get_report_settings
    run User::GetReportSettings

    render User::Cell::GetReportSettings, result["contract.default"]
  end

  def report_settings
    run User::ReportSettings do |result|
      flash[:success] = "Report settings updated!"
      return redirect_to "/users/#{result["model"].id}"
    end

    render User::Cell::GetReportSettings, result["contract.default"]
  end

  def delete_report_settings
    run User::DeleteReportSettings do |result|
      flash[:success] = "Report settings deleted!"
      return redirect_to "/users/#{result["model"].id}"
    end

    render User::Cell::GetReportSettings, result["contract.default"]
  end

  def get_report_template
    run User::GetReportTemplate

    render User::Cell::GetReportTemplate, result["contract.default"]
  end

  def report_template
    run User::ReportTemplate do |result|
      flash[:success] = "Report template updated!"
      return redirect_to "/users/#{result["model"].id}"
    end

    render User::Cell::GetReportTemplate, result["contract.default"]
  end

  def delete_report_template
    run User::DeleteReportTemplate do |result|
      flash[:success] = "Report template deleted!"
      return redirect_to "/users/#{result["model"].id}"
    end

    render User::Cell::GetReportTemplate, result["contract.default"]
  end

private
  def get_name(model)
    name = model.firstname
    if name == nil
      name = model.email
    end
    return name
  end


end
