class VouchersController < InheritedResources::Base

  def index
    #search
  end

  def new
    @voucher = Voucher.new
    @voucher.organ = current_serie.default_organ
  end

  def sub_layout
    "accounting"
  end
end
