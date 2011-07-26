class RenameStuffInVoucherTo_id < ActiveRecord::Migration
  def self.up
    change_table :vouchers do |t|
      t.rename :corrects, :corrects_id
      t.rename :created_by, :created_by_id
    end
  end

  def self.down
    change_table :vouchers do |t|
      t.rename :corrects_id, :corrects
      t.rename :created_by_id, :created_by
    end
  end
end
