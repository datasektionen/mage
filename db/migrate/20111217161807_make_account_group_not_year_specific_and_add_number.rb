class MakeAccountGroupNotYearSpecificAndAddNumber < ActiveRecord::Migration
  def self.up
    remove_column :account_groups, :activity_year_id
    add_column :account_groups, :number, :integer, null: false
  end

  def self.down
    fail ActiveRecord::IrreversibleMigration
  end
end
