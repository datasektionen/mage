class FixVoucherStuff < ActiveRecord::Migration
  def self.up
    change_table :series_organs do |t|
      t.remove :id
      t.remove :default
      t.index :serie_id
      t.index :organ_id
    end
    
    rename_table :voucher_tags, :vouchers_tags
    change_table :vouchers_tags do |t|
      t.index :voucher_id
      t.index :tag_id
    end 
  
    change_table :vouchers do |t|
      t.integer :default_organ
    end
  end

  def self.down
  end
end
