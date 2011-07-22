class AddNumberToArrangement < ActiveRecord::Migration
  def self.up
    add_column :arrangements, :number, :integer, :null=>false
  end

  def self.down
    remove_index :arrangements, :number
  end
end
