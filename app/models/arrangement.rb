class Arrangement < ActiveRecord::Base
  belongs_to :organ
  validates_uniqueness_of :number, :scope => :organ_id

  def to_s
    "#{name} (#{number})"
  end
end
