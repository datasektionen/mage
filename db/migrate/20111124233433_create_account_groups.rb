class CreateAccountGroups < ActiveRecord::Migration
  def self.up
    create_table :account_groups do |t|
      t.string :title
      t.integer :account_type
      t.integer :activity_year_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_groups
  end
end
