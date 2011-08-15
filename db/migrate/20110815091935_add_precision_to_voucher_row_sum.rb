class AddPrecisionToVoucherRowSum < ActiveRecord::Migration
  def self.up
    change_column :voucher_rows, :sum, :decimal, :precision=>12, :scale=>2
  end

  def self.down
  end
end
