class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :number
      t.string :name
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
