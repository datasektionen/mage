class TemplatesController < InheritedResources::Base

  def fields
    @template = VoucherTemplate.find(params[:template])
    @organ = Organ.find(params[:organ])
    render :layout => nil
  end 

  def parse
    arr = params[:arrangement].to_i
    @template = VoucherTemplate.find(params[:template])
    begin
      @rows = @template.parse(params[:fields],arr)
    rescue Exception => e
      render :inline=>e.message, :status=>400 and return
    end
    @sum = @rows.reduce(0) { |s, r| s = s + r.int_sum } 
    render 'vouchers/rows'
  end
end
