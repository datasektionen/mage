class Account < ActiveRecord::Base
  belongs_to :account_group

  #account_types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4

  before_create :set_account_type

  def self.search(s)
    s = "%#{s}%"
    where("number LIKE ? or name LIKE ?", s, s)
  end

  def has_arrangements?
    return account_group.has_arrangements?
  end
end
