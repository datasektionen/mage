class AccountsController < ApplicationController
  def search
    @result = Account.search(params[:activity_year],params[:term]).select([:account_type, :name, :number])
  end

  def index
    @activity_year = ActivityYear.find(params[:activity_year_id])
    @accounts = @activity_year.accounts
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
      Journal.log(:update_accounts,@activity_year, current_user) 
    else
      flash[:error] = t('activemodel.errors.template.header.one', :model=>t('activerecord.models.account_plan'))
    end
    render :action=>:edit
  end

end
