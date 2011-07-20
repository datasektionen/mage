class CreateOrgans < ActiveRecord::Migration
  def self.up
    create_table :organs do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :organs
  end
end
