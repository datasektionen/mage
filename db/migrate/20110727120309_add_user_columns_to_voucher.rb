class AddUserColumnsToVoucher < ActiveRecord::Migration
  def self.up
    change_table :vouchers do |t|
      t.rename :created_by_id, :bookkept_by_id
      t.integer :authorized_by_id, :null => true
      t.integer :material_from_id, :null => true
    end
  end

  def self.down
    t.rename :bookkept_by_id, :created_by_id
    t.remove :authorized_by_id
    t.remove :material_from_id
  end
end
