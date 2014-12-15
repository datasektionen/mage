class CreateVoucherUsers < ActiveRecord::Migration
  def self.up
    create_table :voucher_users do |t|
      t.integer :user_id, null: false
      t.integer :voucher_id, null: false
      t.integer :api_key_id, null: true
      t.string :role, null: false
    end
  end

  def self.down
    drop_table :voucher_users
  end
end
