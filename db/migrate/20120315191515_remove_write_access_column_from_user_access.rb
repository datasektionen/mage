class RemoveWriteAccessColumnFromUserAccess < ActiveRecord::Migration
  def self.up
    UserAccess.where(:write_access=>0).delete_all
    remove_column :user_accesses, :write_access
  end

  def self.down
  end
end
