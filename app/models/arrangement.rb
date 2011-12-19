class Arrangement < ActiveRecord::Base
  belongs_to :organ
  validates_uniqueness_of :number, :scope => :organ_id
  validates_presence_of :number, :name, :organ

  #scope :in_year, lambda { |year| where("? >= starts AND ? <= ends",  year, year) }
  scope :in_year, lambda { |year| all }

  attr_readonly :number

  def to_s
    "#{name} (#{number})"
  end

  def list_print
    "#{number} - #{name}"
  end
end
