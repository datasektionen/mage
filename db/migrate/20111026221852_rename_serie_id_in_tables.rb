class RenameSerieIdInTables < ActiveRecord::Migration
  def self.up
    # remove_index :user_accesses, :serie_id
    rename_column :user_accesses, :serie_id, :series_id
    rename_column :api_accesses, :serie_id, :series_id
    rename_column :vouchers, :serie_id, :series_id
  end

  def self.down
    # raise ActiveRecord::IrreversibleMigration
    rename_column :user_accesses, :series_id, :serie_id
    rename_column :api_accesses, :series_id, :serie_id
    rename_column :vouchers, :series_id, :serie_id
  end
end
