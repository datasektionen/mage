class AccountingController < ApplicationController
  def index
    @menu = 'accounting'
    @serie_options = Series.all
    #@voucers = Voucher.recent.limit(20)
  end
end
