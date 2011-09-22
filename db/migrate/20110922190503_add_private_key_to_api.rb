class AddPrivateKeyToApi < ActiveRecord::Migration
  def self.up
  	 add_column :api_keys, :private_key, :string, :null=>false
  end

  def self.down
  	 drop_column :api_key, :private_key
  end
end
