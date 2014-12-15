class AddApiKeyIdToVoucher < ActiveRecord::Migration
  def self.up
    add_column :vouchers, :api_key_id, :integer, default: nil
  end

  def self.down
    remove_column :vouchers, :api_key_id
  end
end
