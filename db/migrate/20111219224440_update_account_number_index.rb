class UpdateAccountNumberIndex < ActiveRecord::Migration
  def self.up
    remove_index :accounts, ["number"]
    add_index "accounts", ["number", "activity_year_id"], :name => "index_accounts_on_number", :unique => true
  end

  def self.down
    add_index "accounts", ["number"], :name => "index_accounts_on_number", :unique => true
  end
end
