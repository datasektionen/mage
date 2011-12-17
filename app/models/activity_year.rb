class ActivityYear < ActiveRecord::Base
  validates_presence_of :year
  validates_uniqueness_of :year

  has_many :accounts
  accepts_nested_attributes_for :accounts, :allow_destroy=>true
  validates_associated :accounts

  def to_s
    year
  end

  def starts
    DateTime.new(year, 1, 1)
  end

  def ends
    DateTime.new(year, 12, 31)
  end

  def in_year?(date)
    return date >= starts && date <= ends
  end

  # Clones all account groups and accounts into target (an activityyear)
  # Ingoing balance is set to 0 in the new accounts
  def clone_accounts(target)
    target.account_groups << account_groups.collect do |account_group|
      new_account_group = account_group.clone
      new_account_group.accounts << account_group.accounts.collect do |account|
        new_account = account.clone
        new_account.ingoing_balance = 0
        new_account
      end
      new_account_group
    end
  end
end
