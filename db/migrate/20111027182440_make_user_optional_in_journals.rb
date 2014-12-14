class MakeUserOptionalInJournals < ActiveRecord::Migration
  def self.up
    change_column :journal, :user_id, :integer, null: true
  end

  def self.down
    change_column :journal, :user_id, :integer, null: false
  end
end
