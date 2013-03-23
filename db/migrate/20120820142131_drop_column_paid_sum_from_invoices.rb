class DropColumnPaidSumFromInvoices < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :paid_sum
  end

  def self.down
  end
end
