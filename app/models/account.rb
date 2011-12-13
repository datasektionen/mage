class Account < ActiveRecord::Base
  belongs_to :account_group

  #account_types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4

  def self.search(s)
    s = "%#{s}%"
    where("number LIKE ? or name LIKE ?", s, s)
  end

  def has_arrangements?
    return account_group.has_arrangements?
  end

  def activity_year
    return account_group.activity_year
  end

  def account_type
    return account_group.account_type
  end

  def self.find_by_number_and_activity_year(number, activity_year)
    Account.joins(:account_group).first(:conditions=>{:number=>number, "account_groups.activity_year_id"=>activity_year})
  end
end
