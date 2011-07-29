class DropVoucherUsers < ActiveRecord::Migration
  def self.up
    drop_table :voucher_users
  end

  def self.down
    create_table :voucher_users do |t|
      t.integer :user_id, :null=>false
      t.integer :voucher_id, :null=>false
      t.integer :api_key_id, :null=>true
      t.string :role, :null=>false
    end
  end
end
