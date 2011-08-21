class ApiKeysController < InheritedResources::Base
  after_filter LogFilter , :only=>[:create,:update]

  def index
    authorize! :read, ApiKey
    index!
  end

  def new
    authorize! :write, ApiKey
    new!
  end

  def create
    authorize! :write, ApiKey
    @api_key = ApiKey.generate_key(params[:api_key][:name],current_user)
    create!
  end

  def update
    authorize! :write, ApiKey
    update!
  end

  def edit
    @api_key = ApiKey.find(params[:id])
    authorize! :write, @api_key
    @api_key.api_accesses = @api_key.series_access(Serie.all)
  end

  def show
    authorize! :read, ApiKey
    show!
  end

  def destroy
    authorize :delete, ApiKey
    destroy!
  end
  
  def sub_layout
    "main"
  end

end
