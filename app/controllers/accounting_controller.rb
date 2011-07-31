class AccountingController < ApplicationController
  def index
    if can? :read, current_serie
      @vouchers = Voucher.recent(current_serie).limit(20)
    else
      @vouchers = nil
    end
  end

  def sub_layout
    "accounting"
  end
end
