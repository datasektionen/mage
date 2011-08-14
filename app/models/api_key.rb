class ApiKey < ActiveRecord::Base
  belongs_to :created_by, :class_name => "User"

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
end
