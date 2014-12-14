class Invoice < ActiveRecord::Base
  belongs_to :voucher
  has_many :payment_vouchers, class_name: 'Voucher', foreign_key: :pays_invoice_id, inverse_of: :pays_invoice
  validates_presence_of :voucher, :direction, :due_days, :title, :number

  def date
    voucher.accounting_date
  end

  def due_date
    date.advance(days: due_days)
  end

  def sum
    @sum = calculate_sum unless @sum
    @sum
  end

  def paid_sum
    @paid_sum = calculate_paid_sum unless @sum
    @paid_sum || 0
  end

  def fully_paid
    paid_sum >= sum
  end

  # Account type for the rows defining the sum in the invoice voucher
  def sum_account_type
    if direction == :outgoing
      Account::ASSET_ACCOUNT
    else
      Account::DEBT_ACCOUNT
    end
  end

  # Account type for the rows with the paid sum in the payment voucher(s)
  def sum_pay_account_type
    if direction == :ingoing
      Account::ASSET_ACCOUNT
    else
      Account::DEBT_ACCOUNT
    end
  end

  private

  def calculate_sum
    voucher.voucher_rows.reduce(0) do |sum, row|
      sum + (row.account.account_type == sum_account_type ? row.sum : 0).abs
    end
  end

  def calculate_paid_sum
    payment_vouchers.reduce(0) do |sum, voucher|
      sum + voucher.voucher_rows.reduce(0) { |r_sum, row| r_sum + (row.account.account_type == sum_account_type ? row.sum : 0) }.abs
    end
  end
end
