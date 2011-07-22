class Account < ActiveRecord::Base
  #Types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4

  before_create :set_account_type

  def guess_account_type!
    if number <= 1999
      self.type = ASSET_ACCOUNT
    elsif number <= 2999
      self.type = DEBT_ACCOUNT
    elsif number <= 3999
      self.type = INCOME_ACCOUNT
    else
      self.type = COST_ACCOUNT
    end
  end

private 
  def set_account_type
    if type.nil? or type == 0
      guess_account_type!
    end
  end
end
