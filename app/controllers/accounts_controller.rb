class AccountsController < InheritedResources::Base
  load_and_authorize_resource :except=>[:index, :show]
  def search
    @result = Account.search(params[:term]).select([:account_type, :name, :number])
  end

  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find_by_id(params[:id])
  end

end
