class AccountingController < ApplicationController
  def index
    @serie_options = Serie.accessible_by(current_user)
    if current_user.has_access_to?(current_serie)
      @vouchers = Voucher.recent(current_serie).limit(20)
    else
      @vouchers = nil
    end
  end
end
