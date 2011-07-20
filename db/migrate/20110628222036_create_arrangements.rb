class CreateArrangements < ActiveRecord::Migration
  def self.up
    create_table :arrangements do |t|
      t.string :name
      t.integer :organ_id

      t.timestamps
    end
  end

  def self.down
    drop_table :arrangements
  end
end
