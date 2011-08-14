class ApiKey < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User"
  has_many :api_accesses

  accepts_nested_attributes_for :api_accesses

  validates_presence_of :name, :created_by
  validates_uniqueness_of :name, :key

  def self.generate_key(name, current_user)
    api_key = ApiKey.new(:name => name, :created_by => current_user, :key => SecureRandom.hex(32))
    if api_key.save
      api_key
    else
      nil
    end
  end

  def revoked?
    revoked
  end

  def find_access(serie)
    api_accesses.where(:serie_id => serie.id).first
  end

  # Type is :read, :write or :read_write
  def has_access?(serie, type) 
    return false if revoked?
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
