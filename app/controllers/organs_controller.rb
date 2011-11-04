class OrgansController < InheritedResources::Base
  load_and_authorize_resource :except => [:destroy, :index]
  actions :all, :except => :destroy

  def index
    @organs = Organ.all
  end
end
