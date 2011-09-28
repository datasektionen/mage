class AccountingController < ApplicationController
  def index
    if can? :read, current_serie
      @vouchers = Voucher.recent(current_serie).limit(20)
    else
      @vouchers = nil
    end
    @incomplete_vouchers = current_user.series.map { |s| Voucher.incomplete.where(:serie_id=>s.id) }.flatten
  end

  def sub_layout
    "accounting"
  end
end
