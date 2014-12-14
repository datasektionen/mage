class AddValidFromAndValidToToVoucherTemplates < ActiveRecord::Migration
  def self.up
    add_column :voucher_templates, :valid_from, :integer, default: nil
    add_column :voucher_templates, :valid_to, :integer, default: nil
  end

  def self.down
    remove_column :voucher_templates, :valid_to
    remove_column :voucher_templates, :valid_from
  end
end
