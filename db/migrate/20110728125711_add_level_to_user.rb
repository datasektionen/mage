class AddLevelToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :has_access, :boolean, :default=>false
    add_column :user_accesses, :write_access, :boolean, :default => false
  end

  def self.down
    remove_column :users, :has_access
    remove_column :user_accesses, :write_access
  end
end
