class AddTitleToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :title, :string
  end

  def self.down
    remove_column :vouchers, :title
  end
end
