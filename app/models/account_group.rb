class AccountGroup < ActiveRecord::Base
  belongs_to :activity_year
  has_many :accounts

  def has_arrangements?
    return account_type > 2
  end
end
