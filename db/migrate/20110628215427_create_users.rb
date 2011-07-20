class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :ugid, :null => false
      t.string :login, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :persistence_token
      t.boolean :admin
      t.integer :default_serie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
