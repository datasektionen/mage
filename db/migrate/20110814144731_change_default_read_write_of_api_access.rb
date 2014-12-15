class ChangeDefaultReadWriteOfApiAccess < ActiveRecord::Migration
  def self.up
    change_column :api_accesses, :read_write, :string, default: '', null: false
  end

  def self.down
  end
end
