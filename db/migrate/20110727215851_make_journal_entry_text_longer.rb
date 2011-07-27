class MakeJournalEntryTextLonger < ActiveRecord::Migration
  def self.up
    change_column :journal, :message, :text
  end

  def self.down
    change_column :journal, :message, :string
  end
end
