class AccountGroup < ActiveRecord::Base
  belongs_to :activity_year
  has_many :accounts, :dependent=>:destroy
  accepts_nested_attributes_for :accounts, :allow_destroy=>true

  validates :title, :presence=>true
  validates :account_type, :presence=>true
  validates :activity_year, :presence=>true
  validates_associated :accounts

  def has_arrangements?
    return account_type > 2
  end

  def account_type_string
    I18n.t "account_type.type#{account_type}"
  end

  def allow_destroy?
    return true if new_record?
    ! accounts.any? {|account| !account.allow_destroy? } # accounts.all? {|account| account.allow_destroy? }, but this is faster
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
end
