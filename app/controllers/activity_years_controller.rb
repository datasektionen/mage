class ActivityYearsController < ApplicationController
  load_resource :find_by => :year, :except=>[:create]
  authorize_resource :except=>[:index]

  def index
    respond_to do |format|
      format.html do
        @activity_year = ActivityYear.new
        authorize! :manage, @activity_year
      end
      format.json {
        @activity_years = ActivityYear.all
        render :json => @activity_years
      }
    end
  end

  def create
    @activity_year = ActivityYear.new(:year=>params[:activity_year][:year])
    authorize! :create, @activity_year
    if @activity_year.save
      clone_accounts = params[:activity_year][:account][:clone]

      @clone_year = ActivityYear.find(clone_accounts)
      if @clone_year
        @activity_year.accounts = @clone_year.clone_accounts(params[:activity_year][:account][:transfer_saldo])
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
