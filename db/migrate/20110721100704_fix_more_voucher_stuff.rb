class FixMoreVoucherStuff < ActiveRecord::Migration
  def self.up
    change_table :vouchers do |t|
      t.remove :default_organ
    end
    change_table :series do |t|
      t.integer :default_organ_id
    end
  end

  def self.down
    add_column :vouchers, :default_organ, :integer
    remove_column :series, :default_organ_id
  end
end
