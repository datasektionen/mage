class AddColumnSlugToVouchers < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :slug, :string, :null=>false
    puts "Generating slugs for existing models"
    Voucher.find_each(&:save) #Generate slugs for all
    add_index :vouchers, :slug, :unique=>true
  end

  def self.down
    remove_column :vouchers, :slug
  end
end
