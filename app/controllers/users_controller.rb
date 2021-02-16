class UsersController < ApplicationController
  include TrbV21

  def show
    run_v21(User::Operation::Show)
    render User::Cell::Show, @model
  end

  def settings
    run_v21(User::Operation::Show)
    render User::Cell::Settings, @model
  end

  def index
    run_v21(User::Operation::Index)
    render User::Cell::Index, @model
  end

  def create
    run_v21(User::Operation::Create) do
      tyrant.sign_in!(@model)

      flash[:success] = "Welcome #{get_name(@model)}!"
      return redirect_to '/reports'
    end
    render User::Cell::New, @form, layout_type: nil
  end

  def new
    run_v21(User::Operation::Create::Present)

    render User::Cell::New, @form, layout_type: nil
  end

  def edit
    run_v21(User::Operation::Update::Present)

    render User::Cell::Edit, @model
  end

  def update
    run_v21(User::Operation::Update) do
      flash[:success] = 'New details saved'
      return redirect_to "/users/#{@model.id}"
    end

    render User::Cell::Edit, @model
  end

  def destroy
    run_v21(User::Operation::Delete) do
      flash[:danger] = 'User deleted'
      return redirect_to '/sessions/new'
    end

    render User::Cell::Edit, @form
  end

  def get_email
    run(Tyrant::GetEmail)

    render User::Cell::RequestResetPassword, @form, layout_type: nil
  end

  def request_reset_password
    run(User::Operation::ResetPassword) do
      flash[:success] = 'You will receive an email with some instructions!'
      return redirect_to '/sessions/new'
    end

    render User::Cell::RequestResetPassword, @form, layout_type: nil
  end

  def get_new_password
    run(Tyrant::GetNewPassword)
    render User::Cell::ChangePassword, @form
  end

  def change_password
    run(User::Operation::ChangePassword) do
      flash[:danger] = 'The new password has been saved'
      return redirect_to user_path(tyrant.current_user)
    end

    render User::Cell::ChangePassword, @form
  end

  def block
    run_v21(User::Operation::Block) do
      if @model['block'] == true
        flash[:danger] = "#{get_name(@model)} has been blocked"
      else
        flash[:danger] = "#{get_name(@model)} has been un-blocked"
      end
      redirect_to users_path
    end
  end

  def get_report_settings
    run_v21(User::Operation::GetReportSettings)

    render User::Cell::GetReportSettings, @form
  end

  def report_settings
    run_v21(User::Operation::ReportSettings) do
      flash[:success] = 'Report settings updated!'
      return redirect_to "/users/#{@model.id}/settings"
    end

    render User::Cell::GetReportSettings, @form
  end

  def get_report_template
    run_v21(User::Operation::GetReportTemplate)

    render User::Cell::GetReportTemplate, @model
  end

  # def report_template
  #   run User::ReportTemplate do
  #     flash[:success] = "Report template updated!"
  #     return redirect_to "/users/#{@model.id}/settings"
  #   end

  #   render User::Cell::GetReportTemplate, @form
  # end

  def edit_obj
    run_v21(User::Operation::EditObj) do
      flash[:success] = 'Report template updated!'
      return redirect_to "/users/#{@model.id}/get_report_template"
    end

    flash[:danger] = 'Something went wrong and the changes have not been saved!'
    render User::Cell::GetReportTemplate, @model
  end

  def edit_chart
    run_v21(User::Operation::UpdateChart::Present)

    render User::Cell::EditChart, @form
  end

  def update_chart
    run_v21(User::Operation::UpdateChart) do
      flash[:success] = 'Chart updated!'
      return redirect_to "/users/#{@model.id}/get_report_template"
    end

    render User::Cell::EditChart, @form
  end

  def edit_table
    run_v21(User::Operation::UpdateTable::Present)

    render User::Cell::EditTable, @form
  end

  def update_table
    run_v21(User::Operation::UpdateTable) do
      flash[:success] = 'Table updated!'
      return redirect_to "/users/#{@model.id}/get_report_template"
    end

    render User::Cell::EditTable, @form
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
