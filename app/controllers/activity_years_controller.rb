
class ActivityYearsController < ApplicationController
  load_and_authorize_resource :only=>[:index, :create]

  def index
    @activity_year = ActivityYear.new
  end

  def create
    if @activity_year.save
      flash[:notice] = t 'activity_year.created'
      @activity_year = ActivityYear.new
    end

    @activity_years = ActivityYear.all
    render :index
  end
end
