class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!

  
  # Returns the serie set in session[:current_serie] or default_serie if it is not set
  def current_serie
    return Series.from_id(session[:current_serie]) if session[:current_serie]
    return current_user.default_serie
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
