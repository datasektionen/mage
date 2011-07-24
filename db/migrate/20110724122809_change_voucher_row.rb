class ChangeVoucherRow < ActiveRecord::Migration
  def self.up
    change_table :voucher_rows do |t|
      t.remove :canceled
      t.boolean :canceled, :null=>false, :default=>false
      t.rename :changed_by, :signature_id
    end
  end

  def self.down
    change_table :voucher_rows do |t|
      t.date :canceled
      t.remove :canceled
      t.rename :signature_id, :changed_by
    end
  end
end
