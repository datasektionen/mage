class AddColumnNumberToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :number, :string, :null=>false
  end

  def self.down
    remove_column :invoices, :number
  end
end
