module Mage
  class Unauthorized < ::Exception
  end

  class ApiError < ::Exception
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :verify_user!
  before_filter :set_globals

  helper_method :current_activity_year, :current_serie

  rescue_from Mage::Unauthorized do |exception|
    render :file => "#{Rails.root}/public/401.html", :layout => false, :status => 401
  end

  rescue_from Mage::ApiError do |exception|
 	 render :json=> {"status"=>0, "msg"=>"Api Error: #{exception.message}"}, :status=>500
  end	

  #rescue_from CanCan::AccessDenied do |exception|
  #  render 'errors/access_denied', :status=>401 and return false
  #end
  
  # Returns the serie set in session[:current_serie] or default_serie if it is not set
  def current_serie
    if session[:current_serie] and current_user.has_access_to?(s = Series.find(session[:current_serie]))
      s
    elsif current_user.default_serie and current_user.has_access_to?(current_user.default_serie)
      current_user.default_serie
    else
      Series.accessible_by(current_user).first
    end
  end

  def current_activity_year
    return ActivityYear.find(session[:current_activity_year]) if session[:current_activity_year]
    return ActivityYear.order("year").last
  end

  def current_ability
	 unless current_api_key
		Ability.new current_user
	 else
		ApiAbility.new current_api_key
	 end	
  end

  def current_user
	 unless current_api_key
		super
	 else
      u = User.find_or_create_by_ugid(params[:ugid]) if params[:ugid]
      unless u
        raise Mage::ApiError.new("Invalid user or ugid parameter missing")
      else
        u
      end
	 end
  end

  def authenticate_user!
    unless current_api_key
      super
    end
  end

  def current_api_key
  	 return @apikey if @apikey
	 @apikey = ApiKey.authorize(params)
	 if @apikey
      if current_user
        @apikey
      else
        nil
      end
	 elsif params[:apikey]
	 	raise Mage::ApiError.new("Invalid api key")		
	 else
	 	nil
	 end
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

  def sub_layout
    "main"
  end

  protected

  def verify_user!
    redirect_to root_path unless current_api_key || current_user.has_access?
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
