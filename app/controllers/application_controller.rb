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

  respond_to :json, :html

  helper_method :current_activity_year, :current_series

  rescue_from Mage::Unauthorized do |_exception|
    render 'errors/error_401'
  end

  rescue_from CanCan::AccessDenied do |_exception|
    render 'errors/error_401'
  end

  rescue_from Mage::ApiError do |exception|
    render json: { 'errors' => "Api Error: #{exception.message}" }, status: 500
  end

  # Returns the series set in session[:current_series] or default_series if it is not set
  def current_series
    if @current_series
      @current_series
    else
      @current_series = Series.find(session[:current_series]) if session[:current_series]
      if @current_series.nil? && current_user.default_series
        @current_series = current_user.default_series
      elsif @current_series.nil?
        @current_series = Series.all.first
      end
      @current_series
    end
  end

  def current_series=(series)
    session[:current_series] = series.id
    @current_series = series
  end

  def current_activity_year
    if @current_activity_year
      @current_activity_year
    else
      @current_activity_year = ActivityYear.find(session[:current_activity_year]) if session[:current_activity_year]
      if @current_activity_year.nil?
        @current_activity_year = ActivityYear.order('year').last
      end
      @current_activity_year
    end
  end

  def current_activity_year=(activity_year)
    session[:current_activity_year] = activity_year.id
    @current_activity_year = activity_year
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
      if params[:ugid] && !u
        fail Mage::ApiError.new("Could not find user with ugid #{params[:ugid]}")
      elsif u
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
    @apikey = ApiKey.authorize(params, request.body)
    if @apikey
      @apikey
    elsif params[:apikey]
      fail Mage::ApiError.new('Invalid api key')
    end
  end

  # Sets global session values (as specified above)
  def set_globals
    if params[:current_series]
      session[:current_series] = params[:current_series]
      @current_series = nil
    end

    if params[:current_activity_year]
      session[:current_activity_year] = params[:current_activity_year]
      @current_activity_year = nil
    end
  end

  def sub_layout
    'main'
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
