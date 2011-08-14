class RemoveGrantedByFromApiKey < ActiveRecord::Migration
  def self.up
    remove_column :api_accesses, :granted_by_id
  end

  def self.down
    add_column :api_accesses, :granted_by_id, :integer
  end
end
