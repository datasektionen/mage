class AccountGroup < ActiveRecord::Base
  has_many :accounts, :dependent=>:restrict

  validates :title, :presence=>true
  validates :account_type, :presence=>true
  validates :number, :presence=>true

  def allow_destroy?
    accounts.empty?
  end

  def has_arrangements?
    return account_type > 2
  end

  def account_type_string
    I18n.t "account_type.type#{account_type}"
  end
end
