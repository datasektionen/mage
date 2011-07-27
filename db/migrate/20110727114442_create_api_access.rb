class CreateApiAccess < ActiveRecord::Migration
  def self.up
    create_table :api_accesses do |t|
      t.integer :api_key_id, :null=>false
      t.integer :serie_id, :null=>false
      t.integer :granted_by_id
      t.string :read_write, :default => 'r', :null=>false
      t.timestamps
    end

    add_index :api_accesses, :api_key_id
    add_index :api_accesses, :serie_id
  end

  def self.down
    remove_index :api_accesses, :api_key_id
    remove_index :api_accesses, :serie_id

    drop_table :api_accesses
  end
end
