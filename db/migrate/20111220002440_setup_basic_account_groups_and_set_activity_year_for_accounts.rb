# -*- encoding: utf-8 -*-
class SetupBasicAccountGroupsAndSetActivityYearForAccounts < ActiveRecord::Migration
  def self.up
    account_groups = []
    account_groups[1] = AccountGroup.create(title: 'Tillgångar', account_type: 1, number: 1000)
    account_groups[2] = AccountGroup.create(title: 'Skulder', account_type: 2, number: 2000)
    account_groups[3] = AccountGroup.create(title: 'Inkomster', account_type: 3, number: 3000)
    account_groups[4] = AccountGroup.create(title: 'Utgifter', account_type: 4, number: 4000)

    Account.all.each do |account|
      account.account_group = account_groups[1] if account.number < 2000
      account.account_group = account_groups[2] if account.number < 3000 && account.number > 1999
      account.account_group = account_groups[3] if account.number < 4000 && account.number > 2999
      account.account_group = account_groups[4] if account.number > 3999

      account.activity_year = ActivityYear.first if account.activity_year.nil?

      account.save
    end
  end

  def self.down
    fail ActiveRecord::IrreversibleMigration
  end
end
