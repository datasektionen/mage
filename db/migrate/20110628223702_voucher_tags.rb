class VoucherTags < ActiveRecord::Migration
  def self.up
    create_table :voucher_tags, id: false do |t|
      t.integer :voucher_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :voucher_tags
  end
end
