class AccountingController < ApplicationController
  def index
    if can? :read, current_series
      @vouchers = current_activity_year.vouchers.recent(current_series).limit(20)
    else
      @vouchers = nil
    end
    @incomplete_vouchers = current_user.series.map { |s| current_activity_year.vouchers.incomplete.where(:series_id=>s.id) }.flatten
  end

  def sub_layout
    "accounting"
  end
end
