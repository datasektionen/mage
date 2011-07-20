class CreateActivityYears < ActiveRecord::Migration
  def self.up
    create_table :activity_years do |t|
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :activity_years
  end
end
