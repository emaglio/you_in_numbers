class SessionsController < ApplicationController

  def new
    run Session::SignInForm
    render Session::Cell::SignIn, result["contract.default"], layout_type: nil
  end

  def create
    run Session::SignIn do |result|
      tyrant.sign_in!(result["model"])
      flash[:notice] = "Hey mate, welcome back!"
      return redirect_to "/reports"
    end
    render Session::Cell::SignIn, result["contract.default"], layout_type: nil
  end

  def sign_out
    run Session::SignOut do
      tyrant.sign_out!
      flash[:notice] = "See ya!"
      redirect_to root_path
    end
  end
end
