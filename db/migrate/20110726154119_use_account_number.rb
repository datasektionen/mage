class UseAccountNumber < ActiveRecord::Migration
  def self.up
    add_column :voucher_rows, :account_number, :integer, :null=>false
    add_index :accounts, :number, :unique => true
    remove_column :voucher_rows, :account_id
  end

  def self.down
    add_column :voucher_rows, :account_id, :integer, :null=>false
    remove_column :voucher_rows, :account_number
    remove_index :accounts, :number
  end
end
