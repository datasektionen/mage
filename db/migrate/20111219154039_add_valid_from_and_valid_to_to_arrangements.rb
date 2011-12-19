class AddValidFromAndValidToToArrangements < ActiveRecord::Migration
  def self.up
    add_column :arrangements, :valid_from, :integer
    add_column :arrangements, :valid_to, :integer
  end

  def self.down
    remove_column :arrangements, :valid_to
    remove_column :arrangements, :valid_from
  end
end
