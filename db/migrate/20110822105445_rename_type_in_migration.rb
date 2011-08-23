class RenameTypeInMigration < ActiveRecord::Migration
  def self.up
    rename_column :voucher_templates, :type, :template_type
  end

  def self.down
    rename_column :voucher_templates, :template_type, :type
  end
end
