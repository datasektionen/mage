class AccountsController < InheritedResources::Base
  load_and_authorize_resource
  def search
    @result = Account.search(params[:term]).select([:account_type, :name, :number])
  end

end
