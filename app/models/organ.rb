# -*- encoding: utf-8 -*-

class Organ < ActiveRecord::Base
  after_create :create_other_arr

  validates_uniqueness_of :number

  has_many :arrangements

  def to_s
    name
  end

private
  def create_other_arr
    Arrangement.create(:organ_id=>self.id, :name=>"Övrigt", :number=>0)
  end
end
