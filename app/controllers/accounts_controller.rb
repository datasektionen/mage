class AccountsController < InheritedResources::Base
  load_and_authorize_resource :except=>[:index]
  def search
    @result = Account.search(params[:term]).select([:account_type, :name, :number])
  end

  def index
    @accounts = Account.all
  end

end
