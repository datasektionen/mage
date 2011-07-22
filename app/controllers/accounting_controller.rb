class AccountingController < ApplicationController
  def index
    logger.debug "Current_serie: #{current_serie.inspect}"
    if current_user.has_access_to?(current_serie)
      @vouchers = Voucher.recent(current_serie).limit(20)
    else
      @vouchers = nil
    end
  end

  def sub_layout
    "accounting"
  end
end
