class CreateVouchers < ActiveRecord::Migration
  def self.up
    create_table :vouchers do |t|
      t.integer :number
      t.integer :serie_id
      t.integer :organ_id
      t.datetime :accounting_date
      t.integer :created_by, :null=>true
      t.integer :activity_year
      t.integer :corrects

      t.timestamps
    end
  end

  def self.down
    drop_table :vouchers
  end
end
