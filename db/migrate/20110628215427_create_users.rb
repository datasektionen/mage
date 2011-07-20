class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :kthid
      t.string :name
      t.boolean :admin
      t.integer :default_serie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
