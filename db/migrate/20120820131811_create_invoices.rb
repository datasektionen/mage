class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :title, :null => false
      t.enum :direction, :limit => [ :ingoing, :outgoing ]
      t.integer :voucher_id, :null => false
      t.enum :status, :limit => [ :new, :partly_paid, :paid, :canceled ]
      t.decimal :paid_sum, :precision=>12, :scale=>2
      t.integer :due_days, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
