class ActivityYear < ActiveRecord::Base
  validates_presence_of :year
  validates_uniqueness_of :year

  def to_s
    year
  end
end
