class CreateVoucherRows < ActiveRecord::Migration
  def self.up
    create_table :voucher_rows do |t|
      t.integer :voucher_id
      t.integer :account_id
      t.decimal :sum
      t.integer :arrangement_id
      t.boolean :canceled
      t.integer :changed_by

      t.timestamps
    end
  end

  def self.down
    drop_table :voucher_rows
  end
end
