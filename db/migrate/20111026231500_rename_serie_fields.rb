class RenameSerieFields < ActiveRecord::Migration
  def self.up
    rename_column :users, :default_serie_id, :default_series_id
  end

  def self.down
    rename_column :users, :default_series_id, :default_serie_id
  end
end
