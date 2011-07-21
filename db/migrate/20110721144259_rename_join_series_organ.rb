class RenameJoinSeriesOrgan < ActiveRecord::Migration
  def self.up
    rename_table :series_organs, :organs_series
  end

  def self.down
    rename_table :organs_series,  :series_organs
  end
end
