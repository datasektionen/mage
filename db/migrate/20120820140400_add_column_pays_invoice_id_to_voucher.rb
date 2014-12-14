class AddColumnPaysInvoiceIdToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :pays_invoice_id, :integer, default: nil
  end

  def self.down
    remove_column :vouchers, :pays_invoice_id
  end
end
