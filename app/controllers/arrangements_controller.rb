class ArrangementsController < InheritedResources::Base
  #actions :only=>[:new, :create, :edit, :update]
  load_and_authorize_resource :only=>[:new, :create, :edit, :update]

  def new
    @arrangement.organ_id = params[:organ_id]
  end

  def create
    create! do |success, failure|
      success.html {
        flash[:notice] = "Arrangemanget har skapats"
        redirect_to organ_path(@arrangement.organ)
      }
    end
  end

  def update 
    update! do |success, failure|
      success.html {
        flash[:notice] = "Arrangemanget har uppdaterats"
        redirect_to organ_path(@arrangement.organ)
      }
    end
  end
end
