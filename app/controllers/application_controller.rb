class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :set_globals

  helper_method :current_activity_year, :current_serie
  
  # Returns the serie set in session[:current_serie] or default_serie if it is not set
  def current_serie
    return Serie.find(session[:current_serie]) if session[:current_serie]
    return current_user.default_serie if current_user.default_serie
    return Serie.accessible_by(current_user).first
  end

  def current_activity_year
    return ActivityYear.find(session[:current_activity_year]) if session[:current_activity_year]
    return Time.now.year
  end

  # Sets global session values (as specified above)
  def set_globals
    if params[:current_serie]
      session[:current_serie] = params[:current_serie]
    end

    if params[:current_activity_year]
      session[:current_activity_year] = params[:current_activity_year]
    end
  end

  private

  def after_sign_in_path_for(res) 
    stored_location_for(res) || accounting_index_path
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
