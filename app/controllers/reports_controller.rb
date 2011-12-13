class ReportsController < ApplicationController
  def index
  end

  def accounts
    @from = (params.try(:[], "/reports/accounts").try(:[], :from) || 12.months.ago).to_date
    @to = (params.try(:[], "/reports/accounts").try(:[], :to) || Time.zone.now).to_date
    voucher_rows = VoucherRow.where(:canceled => false).joins(:voucher).joins(:account).where(['vouchers.accounting_date >= ? AND vouchers.accounting_date <= ?', @from, @to]).order('accounts.number')
    @accounts = voucher_rows.group_by(:account_number).map{|k, v| {k => v.sum(&:sum)}}.inject({}){|h,i| h.merge(i)}
  end

  def arrangements
  end
end
