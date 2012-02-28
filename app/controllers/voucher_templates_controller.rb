class VoucherTemplatesController < InheritedResources::Base
  load_and_authorize_resource

  def fields
    @voucher_template = VoucherTemplate.find(params[:template])
    @organ = Organ.find(params[:organ])
    @activity_year = ActivityYear.find(params[:activity_year])
    render :layout => nil
  end 

  def parse
    arr = params[:arrangement].to_i
    activity_year_id = params[:activity_year].to_i
    @voucher_template = VoucherTemplate.find(params[:template])
    begin
      @rows = @voucher_template.parse(params[:fields],arr, activity_year_id)
    rescue Exception => e
      render :inline=>e.message, :status=>400 and return
    end
    @sum = @rows.reduce(0) { |s, r| s = s + r.int_sum } 
    render 'vouchers/rows'
  end

  def new
    # Always one input and output field
    @voucher_template.input_fields << TemplateInputField.new
    @voucher_template.output_fields << TemplateOutputField.new
  end
end
