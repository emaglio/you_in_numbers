class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper Formular::RailsHelper

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  class NotAuthorizedError < RuntimeError
  end

  class OpenFileException < RuntimeError
  end # class OpenFileException

  class NotSignedIn < RuntimeError
  end # class OpenFileException

  rescue_from ApplicationController::NotAuthorizedError do
    flash[:danger] = "You are not authorized mate!"
    redirect_to reports_path
  end

  rescue_from ApplicationController::NotSignedIn do
    flash[:danger] = "Sign In or Sign Up please!"
    redirect_to "/sessions/new"
  end


  #exists file and file type are validated in the contract.
  #this is gonna happen when something weird happens
  rescue_from ApplicationController::OpenFileException do
    flash[:danger] = "Something went wrong during file opening..try again! Contact us if it happens again!"
    redirect_to "/reports/new"
  end


  def render(cell_constant, model, options: {}, layout_type: "app", type: "html", method: :append)

    layout_types = {
      "welcome" => RailsBootstrap::Cell::WelcomeLayout,
      "app" => RailsBootstrap::Cell::Layout,
      nil => nil
    }

    layout = layout_types[layout_type]


    if type == "html"
      super(
            html: cell(
                  cell_constant,
                  model,
                  { layout: layout,
                    context: {current_user: tyrant.current_user, flash: flash}
                    }.merge(options))
            )
    else
      super(
            js: concept(
                        cell_constant,
                        model
                        ).(method)
            )
    end
  end

  def current_user
    tyrant.current_user
  end


private
  def _run_options(options)
    options.merge("current_user" => tyrant.current_user )
  end
end
