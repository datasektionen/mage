class ActivityYear < ActiveRecord::Base
  validates_presence_of :year
  validates_uniqueness_of :year

  has_many :accounts, :order=>:number
  accepts_nested_attributes_for :accounts, :allow_destroy=>true
  validates_associated :accounts
  has_many :vouchers

  def to_s
    year
  end

  def to_log
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

  def to_param
    return year.to_s
  end

  # Clones all accounts nd accounts into target (an activityyear)
  # Ingoing balance is set to 0 in the new accounts
  # activity_year_id is set to nil
  def clone_accounts
    accounts.collect do |account|
      new_account = account.clone
      new_account.ingoing_balance = 0
      new_account.activity_year = nil
      new_account
    end
  end

  # Fetch the correct activity year from a given date
  def self.find_by_date(d)
    # At the moment only calender years are supported as activity years
    find_by_year(d.year)
  end
end
