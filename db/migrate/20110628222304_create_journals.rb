class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journal do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :journal
  end
end
