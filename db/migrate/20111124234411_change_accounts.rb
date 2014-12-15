class ChangeAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :account_type
    change_table :accounts do |t|
      t.integer :account_group_id, null: false
      t.integer :ingoing_balance, default: 0
    end
  end

  def self.down
    change_table :accounts do |t|
      t.integer :account_type, null: false
    end
    remove_column :accounts, :account_group_id
    remove_column :accounts, :ingoing_balance
  end
end
