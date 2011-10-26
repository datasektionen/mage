class ApiKey < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User"
  has_many :api_accesses

  accepts_nested_attributes_for :api_accesses

  validates_presence_of :name, :created_by
  validates_uniqueness_of :name, :key

  def self.generate_key(name, current_user)
    api_key = ApiKey.new(:name => name, :created_by => current_user, :key => SecureRandom.hex(32), :private_key => SecureRandom.hex(8))
    if api_key.save
      api_key
    else
      nil
    end
  end

  def self.authorize(params,body) 
    if params[:apikey]
      api_key = self.find_by_key(params[:apikey])
      checksum = ApiCall::create_hash(body.read,api_key.private_key)
      Rails.logger.debug("Calculated checksum: #{  checksum }")
      if params[:checksum] == checksum
        return api_key
      else
        return nil
      end
    else
      nil
    end
  end

  def revoked?
    revoked
  end

  def find_access(series)
    api_accesses.where(:series_id => series.id).first
  end

  # Type is :read, :write or :read_write
  def has_access?(series=nil, type=nil) 
    return false if revoked?
	 return true if series.nil? && type.nil?
    a = find_access(series)
    return false if a.nil?

    a.has_access? type
  end

  # Returns a list of ApiAccess objects, one
  # for each series in series
  def series_access(series)
    ApiAccess.for_series(series, self)
  end

  def to_s
    return name
  end

end
