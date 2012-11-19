module VoucherActions
  def new_voucher
    voucher = Voucher.new
    voucher.organ = current_series.default_organ || Organ.first
    voucher.series = current_series
    voucher.activity_year = current_activity_year
    last_user_voucher = current_user.vouchers.where(:series_id=>current_series.id, :activity_year_id=>current_activity_year.id).last
    last_voucher = Voucher.where(:series_id=>current_series.id, :activity_year_id=>current_activity_year.id).last
    if last_user_voucher
      voucher.accounting_date = last_user_voucher.accounting_date
      voucher.organ = last_user_voucher.organ
    elsif last_voucher
      voucher.accounting_date = last_voucher.accounting_date
      voucher.organ = last_voucher.organ
    else
      voucher.accounting_date = Time.now 
    end
    
    voucher
  end

  def create_voucher(params)
    params[:voucher].delete(:add_row)
    Voucher.new(params[:voucher])
  end
end
