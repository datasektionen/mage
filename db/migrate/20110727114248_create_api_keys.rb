class CreateApiKeys < ActiveRecord::Migration
  def self.up
    create_table :api_keys do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.boolean :revoked, default: 0
      t.integer :created_by_id, null: false
      t.timestamps
    end

    add_index :api_keys, :key, unique: true
  end

  def self.down
    remove_index :api_keys, :key

    drop_table :api_keys
  end
end
