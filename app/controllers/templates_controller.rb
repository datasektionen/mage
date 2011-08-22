class TemplatesController < InheritedResources::Base

  def fields
    @template = VoucherTemplate.find(params[:template])
    authorize! :read, @template
    render :layout => nil
  end 

  def parse
    arr = params[:arrangement].to_i
    @template = VoucherTemplate.find(params[:template])
    authorize! :read, @template
    @rows = @template.parse(params[:fields],arr)
    @sum = @rows.reduce(0) { |s, r| s = s + r.sum } 
    render 'vouchers/rows'
  end
end
