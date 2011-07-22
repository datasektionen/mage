class Organ < ActiveRecord::Base
  after_create :create_other_arr

  has_many :arrangements

private
  def create_other_arr
    Arrangement.create(:organ_id=>self.id, :name=>"Övrigt", :number=>0)
  end
end
