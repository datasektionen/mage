class RenameJournalObjectModelToType < ActiveRecord::Migration
  def self.up
    rename_column :journal, :object_model, :object_type
  end

  def self.down
    rename_column :journal, :object_type, :object_model
  end
end
