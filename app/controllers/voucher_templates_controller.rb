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

  def clone
    @voucher_template = VoucherTemplate.find(params[:id])
    authorize! :read, @voucher_template
    authorize! :write, VoucherTemplate.new
    cloned = @voucher_template.clone
    cloned.name+=" (#{t('copy')})"
    cloned.save
    redirect_to voucher_template_path(cloned)
  end

  def destroy 
    destroy! do |success, failure|
      success.html {
        flash[:notice] = t('voucher_templates.delete_success')
        redirect_to voucher_templates_path
      }
    end     
  end
end
