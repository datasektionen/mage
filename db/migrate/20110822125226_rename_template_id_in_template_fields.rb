class RenameTemplateIdInTemplateFields < ActiveRecord::Migration
  def self.up
    rename_column :template_input_fields, :template_id, :voucher_template_id
    rename_column :template_output_fields, :template_id, :voucher_template_id
  end

  def self.down
    rename_column :template_input_fields, :voucher_template_id, :template_id
    rename_column :template_output_fields, :voucher_template_id, :template_id
  end
end
