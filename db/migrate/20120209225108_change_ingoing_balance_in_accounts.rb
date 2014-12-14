class ChangeIngoingBalanceInAccounts < ActiveRecord::Migration
  def self.up
    change_column :accounts, :ingoing_balance, :decimal, precision: 12, scale: 2, default: 0
  end

  def self.down
    change_column :accounts, :ingoing_balance, :integer, default: 0
  end
end
