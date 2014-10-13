class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.string :description
      t.integer :type
      t.timestamps
    end

    create_table :template_input_fields do |t|
      t.integer :template_id
      t.string :name
      t.string :description
      t.string :script_name
    end

    create_table :template_output_fields do |t|
      t.integer :template_id
      t.integer :account_number
      t.string :formula
      t.string :script_name
    end

    add_index :template_input_fields, :template_id
    add_index :template_output_fields, :template_id
  end

  def self.down
    remove_index :template_input_fields, :template_id
    remove_index :template_output_fields, :template_id

    drop_table :templates
    drop_table :template_input_fields
    drop_table :template_output_fields
  end
end
