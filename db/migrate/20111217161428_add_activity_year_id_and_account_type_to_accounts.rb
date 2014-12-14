class AddActivityYearIdAndAccountTypeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :activity_year_id, :integer, null: false
    add_column :accounts, :debet_is_normal, :boolean, default: true
    add_column :accounts, :kredit_is_normal, :boolean, default: true

    Account.all.each do |account|
      account.activity_year = ActivityYear.first
      unless account.account_group.nil?
        if account.account_type == Account::INCOME_ACCOUNT
          account.debet_is_normal = false
        elsif account.account_type == Account::COST_ACCOUNT
          account.kredit_is_normal = false
        end
      end
      account.save
    end
  end

  def self.down
    remove_column :accounts, :activity_year_id
    remove_column :accounts, :debet_is_normal
    remove_column :accounts, :kredit_is_normal
  end
end
