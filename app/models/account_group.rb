class AccountGroup < ActiveRecord::Base
  belongs_to :activity_year
  has_many :accounts

  validates :title, :presence=>true
  validates :account_type, :presence=>true
  validates :activity_year, :presence=>true

  def has_arrangements?
    return account_type > 2
  end
end
