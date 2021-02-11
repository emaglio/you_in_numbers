require 'uri'
require 'net/http'
require 'json'

class SessionsController < ApplicationController
  include TrbV21

  def new
    run_v21(Session::Operation::SignIn::Form)
    render Session::Cell::SignIn, result['contract.default'], layout_type: nil
  end

  def create
    run_v21(Session::Operation::SignIn) do |result|
      tyrant.sign_in!(result['model'])
      flash[:success] = 'Hey mate, welcome back!'
      return redirect_to '/reports'
    end
    render Session::Cell::SignIn, result['contract.default'], layout_type: nil
  end

  def sign_out
    run_v21(Session::Operation::SignOut) do
      tyrant.sign_out!
      flash[:success] = 'See ya!'
      redirect_to '/sessions/new'
    end
  end

  def github
    run_v21(Session::GitHub) do |result|
      tyrant.sign_in!(result['model'])
      flash[:success] = 'Hey mate'
      return redirect_to '/reports'
    end
    flash[:danger] = result['failure_message']
    render Session::Cell::SignIn, result['contract.default'], layout_type: nil
  end
end
