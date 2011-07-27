class CreateJournalColumns < ActiveRecord::Migration
  def self.up
    change_table :journal do |t|
      t.string :message, :null=>false
      t.integer :user_id, :null=>false
      t.integer :api_key_id, :null=>true
      t.integer :object_id, :null=>true
      t.string :object_model, :null=>true
    end
  end

  def self.down
    change_table :journal do |t|
      t.remove :messageg
      t.remove :user_idg
      t.remove :api_key_idg
      t.remove :object_idg
      t.remove :object_modelg
    end
  end
end
