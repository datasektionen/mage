class OrgansController < InheritedResources::Base
  load_and_authorize_resource :except => :destroy
  actions :all, :except => :destroy

end
