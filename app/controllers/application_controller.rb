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

  rescue_from ApplicationController::NotAuthorizedError do
    flash[:danger] = "You are not authorized mate!"
    redirect_to reports_path
  end


  def render(cell_constant, model, options: {}, layout_type: "app")

    layout_types = {
      "welcome" => RailsBootstrap::Cell::WelcomeLayout,
      "app" => RailsBootstrap::Cell::Layout,
      nil => nil
    }

    layout = layout_types[layout_type]


    super(
          html: cell(
                cell_constant,
                model,
                { layout: layout,
                  context: {current_user: tyrant.current_user, flash: flash}
                  }.merge(options))
          )
  end

  def current_user
    tyrant.current_user
  end


private
  def _run_options(options)
    options.merge("current_user" => tyrant.current_user )
  end
end
