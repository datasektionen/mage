class DropInvoiceStuff < ActiveRecord::Migration
  def self.up
    remove_column :vouchers, :pays_invoice_id
    drop_table :invoices
  end

  def self.down
  end
end
