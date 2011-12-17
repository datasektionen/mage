class ActivityYearsController < ApplicationController
  load_and_authorize_resource :only=>[:index]

  def index
    @activity_year = ActivityYear.new
  end

  def create
    @activity_year = ActivityYear.new(:year=>params[:activity_year][:year])
    if @activity_year.save
      clone_accounts = params[:activity_year][:accounts][:clone]
      
      @clone_year = ActivityYear.find(clone_accounts)
      if @clone_year
        @clone_year.clone_accounts(@activity_year)
      end

      if @activity_year.save
        flash[:notice] = t 'activity_year.created'
        @activity_year = ActivityYear.new
      end
    end


    @activity_years = ActivityYear.all
    render :index
  end
end
