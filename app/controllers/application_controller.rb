class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  private


  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
