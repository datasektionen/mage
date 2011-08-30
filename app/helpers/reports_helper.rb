module ReportsHelper
  def rows_for(arrangement)
    voucher_rows = VoucherRow.where(:canceled => false).joins(:voucher).joins(:account).order('accounts.number')
    voucher_rows = voucher_rows.where(:arrangement_id => arrangement.id)
    voucher_rows.group_by(&:account).map{|k, v| {k => v.sum(&:sum)}}.inject({}){|h,i| h.merge(i)}
  end
end
