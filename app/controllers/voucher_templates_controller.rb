class VoucherTemplatesController < InheritedResources::Base
  def fields
    @voucher_template = VoucherTemplate.find(params[:template])
    @organ = Organ.find(params[:organ])
    render :layout => nil
  end 

  def parse
    arr = params[:arrangement].to_i
    @voucher_template = VoucherTemplate.find(params[:template])
    begin
      @rows = @voucher_template.parse(params[:fields],arr)
    rescue Exception => e
      render :inline=>e.message, :status=>400 and return
    end
    @sum = @rows.reduce(0) { |s, r| s = s + r.int_sum } 
    render 'vouchers/rows'
  end
end
