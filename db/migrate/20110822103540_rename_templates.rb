class RenameTemplates < ActiveRecord::Migration
  def self.up
    rename_table :templates, :voucher_templates
  end

  def self.down
    rename_table :voucher_templates, :templates
  end
end
