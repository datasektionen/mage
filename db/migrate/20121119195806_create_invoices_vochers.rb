class CreateInvoicesVochers < ActiveRecord::Migration
  def self.up
    create_table :invoices_vouchers, :id=>false do |t|
      t.integer :invoice_id, :null=>false
      t.integer :voucher_id, :null=>false
    end
  end

  def self.down
    drop_table :invoices_vouchers
  end
end
