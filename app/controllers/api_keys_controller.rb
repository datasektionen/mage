class ApiKeysController < InheritedResources::Base
  load_and_authorize_resource :except=>:create
  after_filter LogFilter , :only=>[:create,:update]


  def create
    authorize! :write, ApiKey
    @api_key = ApiKey.generate_key(params[:api_key][:name],current_user)
    create!
  end

  def edit
    @api_key.api_accesses = @api_key.series_access(Series.all)
  end

  def sub_layout
    "main"
  end

end
