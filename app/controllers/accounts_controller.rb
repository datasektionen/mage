class AccountsController < ApplicationController
  def search
    @result = Account.search(params[:activity_year],params[:term]).select([:account_type, :name, :number])
  end

  def index
    @account_groups = AccountGroup.where(:activity_year_id=>params[:activity_year_id])
  end

  def show
    @account = Account.find_by_id(params[:activity_year_id])
  end

  # Multi edit
  def edit
    @activity_year = ActivityYear.find(params[:activity_year_id])
    authorize! :update, @activity_year
  end

  # Multi update
  def update
    @activity_year = ActivityYear.find(params[:activity_year_id])
    authorize! :update, @activity_year
    if @activity_year.update_attributes(params[:activity_year])
      flash[:notice] = t('accounts.changes_saved')
    else
      flash[:notice] = "error"
    end
    render :action=>:edit
  end

end
