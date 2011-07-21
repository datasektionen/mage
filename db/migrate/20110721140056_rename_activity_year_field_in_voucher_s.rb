class RenameActivityYearFieldInVoucherS < ActiveRecord::Migration
  def self.up
    rename_column :vouchers, :activity_year, :activity_year_id
  end

  def self.down
    rename_column :vouchers, :activity_year, :activity_year_id
  end
end
