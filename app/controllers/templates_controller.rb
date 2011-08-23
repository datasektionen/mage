class TemplatesController < InheritedResources::Base

  def fields
    @template = VoucherTemplate.find(params[:template])
    @organ = Organ.find(params[:organ])
    authorize! :read, @template
    render :layout => nil
  end 

  def parse
    arr = params[:arrangement].to_i
    @template = VoucherTemplate.find(params[:template])
    authorize! :read, @template
    begin
      @rows = @template.parse(params[:fields],arr)
    rescue Exception => e
      render :inline=>e, :status=>400 and return
    end
    @sum = @rows.reduce(0) { |s, r| s = s + r.sum } 
    render 'vouchers/rows'
  end
end
