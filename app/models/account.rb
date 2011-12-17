class Account < ActiveRecord::Base
  belongs_to :account_group
  belongs_to :activity_year

  validate :dont_change_number_if_used

  validates :name, :presence=>true
  validates :number, :presence=>true, :uniqueness=>{:scope=>:activity_year_id}
  validates :account_group, :presence=>true
  validates :activity_year, :presence=>true

  #account_types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4


  def self.search(activity_year_id,s)
    s = "%#{s}%"
    where("activity_year_id = ? accounts.number LIKE ? or accounts.name LIKE ?",activity_year_id, s, s)
  end

  def has_arrangements?
    return account_group.has_arrangements?
  end

  def account_type
    return account_group.account_type
  end

  def allow_destroy?
    return usage.empty?
  end

  def usage
    return [] if new_record?
    return Voucher.find_by_account_and_activity_year(number_was, activity_year_id)
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
