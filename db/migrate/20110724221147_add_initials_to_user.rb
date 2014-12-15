class AddInitialsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :initials, :string, null: false
  end

  def self.down
    remove_column :users, :initials
  end
end
