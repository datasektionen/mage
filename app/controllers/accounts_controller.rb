class AccountsController < InheritedResources::Base
  def search
    @result = Account.search(params[:term]).select([:account_type, :name, :number])
  end

end
