class ActivityYear < ActiveRecord::Base
  validates_presence_of :year
  validates_uniqueness_of :year

  has_many :account_groups
  accepts_nested_attributes_for :account_groups, :allow_destroy=>true

  def to_s
    year
  end

  def starts
    DateTime.new(year, 1, 1)
  end

  def ends
    DateTime.new(year, 12, 31)
  end

  def in_year?(date)
    return date >= starts && date <= ends
  end
end
