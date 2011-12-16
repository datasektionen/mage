class Account < ActiveRecord::Base
  belongs_to :account_group

  validate :dont_change_number_if_used

  validates :number, :presence=>true
  validates :name, :presence=>true, :uniqueness=>true

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
    joins(:account_group).where("account_groups.activity_year_id"=>activity_year)
  end 

  def self.find_by_number_and_activity_year(number, activity_year)
    joins(:account_group).first(:conditions=>{:number=>number, "account_groups.activity_year_id"=>activity_year})
  end

  def allow_destroy?
    return usage.empty?
  end

  def usage
    return [] if new_record?
    return Voucher.find_by_account_and_activity_year(number_was, account_group.activity_year)
  end

private 
  alias destroy_ destroy

public
  def destroy
    if allow_destroy?
      destroy_
    else
      false
    end
  end

protected
  def dont_change_number_if_used
    if !allow_destroy?
      errors[:number] << I18n.t('activerecord.messages.is_readonly') if changed.include?("number")
    end
  end
end
