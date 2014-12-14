class AddColumnDeletedToVoucherTemplates < ActiveRecord::Migration
  def self.up
    add_column :voucher_templates, :is_deleted, :bool, default: false
  end

  def self.down
    remove_column :voucher_templates, :is_deleted
  end
end
