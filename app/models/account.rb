class Account < ActiveRecord::Base
  #account_types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4

  before_create :set_account_type

  def guess_account_type!
    if number <= 1999
      self.account_type = ASSET_ACCOUNT
    elsif number <= 2999
      self.account_type = DEBT_ACCOUNT
    elsif number <= 3999
      self.account_type = INCOME_ACCOUNT
    else
      self.account_type = COST_ACCOUNT
    end
  end

  def self.search(s)
    s = "%#{s}%"
    where("number LIKE ? or name LIKE ?", s, s)
  end

  def has_arrangements?
    return account_type > 2
  end

private 
  def set_account_type
    if account_type.nil? or account_type == 0
      guess_account_type!
    end
  end
end
