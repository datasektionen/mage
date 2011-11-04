class AddNumberToOrgans < ActiveRecord::Migration
  def self.up
    add_column :organs, :number, :integer
    Organ.all.each do |o|
      o.number = o.id
      o.save
    end
  end

  def self.down
    remove_column :organs, :number
  end
end
