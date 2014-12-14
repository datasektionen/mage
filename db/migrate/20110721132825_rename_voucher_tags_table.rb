class RenameVoucherTagsTable < ActiveRecord::Migration
  def self.up
    rename_table :vouchers_tags, :tags_vouchers
  end

  def self.down
    rename_table :tags_vouchers, :vouchers_tags
  end
end
