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
  end

end
