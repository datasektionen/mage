class ArrangementsController < InheritedResources::Base
  # actions :only=>[:new, :create, :edit, :update]
  load_and_authorize_resource only: [:new, :create, :edit, :update, :index]

  def new
    @arrangement.organ_id = params[:organ_id]
  end

  def create
    create! do |success, _failure|
      success.html do
        flash[:notice] = 'Arrangemanget har skapats'
        redirect_to organ_path(@arrangement.organ)
      end
    end
  end

  def update
    update! do |success, _failure|
      success.html do
        flash[:notice] = 'Arrangemanget har uppdaterats'
        redirect_to organ_path(@arrangement.organ)
      end
    end
  end

  def show
    @arrangements = Arrangement.in_year(params[:id]).includes(:organ)
    if params[:organ_number]
      @arrangements = @arrangements.joins(:organ).where('organs.number = ?', params[:organ_number])
    end
    render action: :index
  end
end
