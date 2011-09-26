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

  def self.authorize(params) 
    if params[:apikey]
      tmp = params.clone
      tmp.delete :checksum
      api_key = self.find_by_key(params[:apikey])
      if params[:checksum] == api_key.create_hash(tmp) 
        return api_key
      else
        return nil
      end
    else
      nil
    end
  end

  def create_hash(params)
    require 'digest/sha1'
    Digest::SHA1.hexdigest(params.map {|obj| "#{obj[0]}=#{obj[1]}" }.join(",")+private_key)
  end

  def revoked?
    revoked
  end

  def find_access(serie)
    api_accesses.where(:serie_id => serie.id).first
  end

  # Type is :read, :write or :read_write
  def has_access?(serie=nil, type=nil) 
    return false if revoked?
	 return true if serie.nil? && type.nil?
    a = find_access(serie)
    return false if a.nil?

    a.has_access? type
  end

  # Returns a list of ApiAccess objects, one
  # for each serie in series
  def series_access(series)
    ApiAccess.for_series(series, self)
  end

end
