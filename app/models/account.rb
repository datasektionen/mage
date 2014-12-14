class Account < ActiveRecord::Base
  belongs_to :account_group
  belongs_to :activity_year

  validate :dont_change_number_if_used

  validates :name, presence: true
  validates :number, presence: true, uniqueness: { scope: :activity_year_id }
  validates :account_group, presence: true
  validates :activity_year, presence: true

  # account_types
  ASSET_ACCOUNT = 1
  DEBT_ACCOUNT = 2
  INCOME_ACCOUNT = 3
  COST_ACCOUNT = 4

  def self.search(activity_year_id, s)
    s = "%#{s}%"
    where('activity_year_id = ? accounts.number LIKE ? or accounts.name LIKE ?', activity_year_id, s, s)
  end

  delegate :has_arrangements?, to: :account_group
  delegate :account_type, to: :account_group

  def allow_destroy?
    usage.empty?
  end

  def usage
    return [] if new_record?
    Voucher.find_by_account_and_activity_year(number_was, activity_year_id)
  end

  def destroy
    if allow_destroy?
      super
    else
      false
    end
  end

  # Returns the result of this account for this year
  # (sum of all voucher rows with this account)
  def result
    VoucherRow.joins(:voucher).where(:account_number => number, 'vouchers.activity_year_id' => activity_year_id, :canceled => false).sum(:sum).to_f
  end

  def current_balance
    ingoing_balance + result
  end

  def to_s
    "#{number} #{name}"
  end

  protected

  def dont_change_number_if_used
    unless allow_destroy?
      errors[:number] << I18n.t('activerecord.messages.is_readonly') if changed.include?('number')
    end
  end
end
