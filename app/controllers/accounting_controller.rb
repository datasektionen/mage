class AccountingController < ApplicationController
  def index
    @menu = 'accounting'
    @serie_options = Serie.accessible_by(current_user)
    @serie = current_serie
    if current_user.has_access_to?(@serie)
      @voucers = Voucher.recent(@serie).limit(20)
    else 
      @serie = nil
    end
  end
end
