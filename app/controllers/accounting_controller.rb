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

  def navigate
    if params[:target] && !params[:target].empty?
      s = Series.find_by_letter(params[:target][0])
      if !s.nil?
        redirect_to voucher_path("#{current_activity_year.year}-#{params[:target]}")
      else
        redirect_to voucher_path("#{current_activity_year.year}-#{current_series.letter}#{params[:target]}")
      end
    else
      flash[:error] = t('vouchers.invalid_number')
      redirect_to accounting_index_path
    end
  end
end
