class RemoveSeriesOrgan < ActiveRecord::Migration
  def self.up
    drop_table :organs_series
  end

  def self.down
  end
end
