class AddNumberToArrangement < ActiveRecord::Migration
  def self.up
    add_column :arrangement, :number, :integer, :null=>false

    add_index :arrangement, :number
  end

  def self.down
    remove_index :arrangement, :number
    remove_column :arrangement, :number
  end
end
