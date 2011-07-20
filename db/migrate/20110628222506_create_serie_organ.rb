class CreateSerieOrgan < ActiveRecord::Migration
  def self.up
    create_table :series_organs do |t|
      t.integer :serie_id, :null => false
      t.integer :organ_id, :null => false
      t.boolean :default, :null => false, :default => false
    end
  end

  def self.down
    drop_table :series_organs
  end
end
