class SeriesController < InheritedResources::Base
  load_and_authorize_resource except: [:index]

  def index
    @series = Series.all
  end
end
