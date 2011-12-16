class Account < ActiveRecord::Base
  belongs_to :account_group

  #account_types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4

  def self.search(activity_year,s)
    s = "%#{s}%"
    joins(:account_group).where("account_groups.activity_year = ? accounts.number LIKE ? or accounts.name LIKE ?",activity_year, s, s)
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

  def self.find_by_activity_year(activity_year)
    joins(:account_group).where(:activity_year_id=>activity_year)
  end 

  def self.find_by_number_and_activity_year(number, activity_year)
    joins(:account_group).first(:conditions=>{:number=>number, :activity_year_id=>activity_year})
  end
end
