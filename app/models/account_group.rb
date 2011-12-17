class AccountGroup < ActiveRecord::Base
  has_many :accounts

  validates :title, :presence=>true
  validates :account_type, :presence=>true
  validates :number, :presence=>true

  def has_arrangements?
    return account_type > 2
  end

  def account_type_string
    I18n.t "account_type.type#{account_type}"
  end

  def allow_destroy?
    return true if new_record?
    return accounts.empty? #Dont allow destroy if it has any accounts
  end

  def destroy
    if allow_destroy?
      super
    else
      false
    end
  end
end
