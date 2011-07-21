class CreateAccess < ActiveRecord::Migration
  def self.up
    create_table :user_accesses do |t|
      t.integer :user_id
      t.integer :serie_id
      t.integer :granted_by_id
      t.timestamps
    end
    add_index :user_accesses, :user_id
    add_index :user_accesses, :serie_id
  end

  def self.down
    drop_table :user_accesses
  end
end
