class AccountingController < ApplicationController
  def index
    if can? :read, current_series
      @vouchers = Voucher.recent(current_series).limit(20)
    else
      @vouchers = nil
    end
    @incomplete_vouchers = current_user.series.map { |s| Voucher.incomplete.where(:series_id=>s.id) }.flatten
  end

  def sub_layout
    "accounting"
  end
end
