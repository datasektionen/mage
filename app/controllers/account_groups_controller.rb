class AccountGroupsController < InheritedResources::Base
  load_and_authorize_resource

  protected

  def collection
    @account_groups ||= AccountGroup.order(:number)
  end
end
