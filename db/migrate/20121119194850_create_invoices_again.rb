class CreateInvoicesAgain < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :counterpart
      t.string :reference
      t.date :expire_date
      t.boolean :supplier_invoice

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
