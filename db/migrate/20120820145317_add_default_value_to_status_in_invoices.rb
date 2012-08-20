class AddDefaultValueToStatusInInvoices < ActiveRecord::Migration
  def self.up
    change_column :invoices, :status, :enum, :limit => [:new, :partly_paid, :paid, :canceled], :default => :new
  end

  def self.down
  end
end
