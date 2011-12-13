# -*- encoding: utf-8 -*-
class VouchersController < InheritedResources::Base 
  actions :all
  after_filter LogFilter , :only=>[:create,:update, :destroy]

  def index
    @vouchers = Voucher.search(params[:search], current_activity_year, current_user).page(params[:page])
  end

  def new
    @voucher = Voucher.new
    @voucher.organ = current_series.default_organ || Organ.first
    @voucher.series = current_series
    @voucher.activity_year = current_activity_year
    last_voucher = Voucher.where(:series_id=>current_series.id).last
    @voucher.accounting_date = Time.now 
    @voucher.accounting_date = last_voucher.accounting_date unless last_voucher.nil?

    authorize! :write, @voucher

    if params[:correct]
      @voucher.corrects = Voucher.find(params[:correct])
      @voucher.voucher_rows = @voucher.corrects.inverted_rows
      @voucher.title = "Rättar #{@voucher.corrects}"
    end
  end

  def create
    params[:voucher].delete(:add_row)
    @voucher = Voucher.new(params[:voucher])
    authorize! :write, @voucher
    if not current_api_key
      @voucher.bookkept_by = current_user
      @voucher.set_number!
    else
      @voucher.bookkept_by = nil
      @voucher.api_key = current_api_key
    end
    @voucher.material_from = current_user
    create! do |success, failure|
      success.html { 
        flash[:notice] = "Verifikat <a href='#{voucher_path(@voucher)}'>#{@voucher.pretty_number}</a> skapades"
        redirect_to new_voucher_path
      }
    end
  end

  def complete
    if current_api_key.nil?
      @vouchers = Voucher.unscoped.find(:all,:conditions=>{:id=>params[:vouchers]})
      authorize! :write, @vouchers
      @vouchers.each do |v|
        unless v.bookkept?
          v.bookkept_by = current_user 
          if v.save
            Journal.log(:complete,v,current_user, nil)
          end
        end
      end
      flash[:notice] = t 'vouchers.bookkept_plural'
    end
    redirect_to accounting_index_path
  end

  def api_create
    unless params[:voucher]
      raise Mage::ApiError.new("Voucher data missing")
    end
    params[:voucher][:series] = Series.find_by_letter(params[:voucher][:series])
    if params[:voucher][:series].nil?
      raise Mage::ApiError.new("Invalid series letter")
    end

    unless params[:voucher][:organ]
      params[:voucher][:organ] = params[:voucher][:series].default_organ
    else
      params[:voucher][:organ] = Organ.find_by_number(params[:voucher][:organ])
      if params[:voucher][:organ].nil?
        raise Mage::ApiError.new("Invalid organ number")
      end
    end

    params[:voucher][:activity_year] = ActivityYear.find_by_year(params[:voucher][:activity_year])
    params[:voucher][:authorized_by] = User.find_or_create_by_ugid(params[:voucher][:authorized_by])
    params[:voucher][:material_from] = User.find_or_create_by_ugid(params[:voucher][:material_from])

    # Parse arrangement number to id
    #params[:voucher][:arrangement]
    params[:voucher][:voucher_rows_attributes].each do |vr|
      vr[:arrangement] = params[:voucher][:organ].arrangements.find_by_number(vr[:arrangement]) if vr[:arrangement]
      vr[:arrangement] = nil unless Account.find_by_number(vr[:account_number]).has_arrangements?
    end


    @voucher = Voucher.new(params[:voucher])
    begin
      authorize! :write, @voucher
    rescue CanCan::AccessDenied
      render :status=>403, :json => {"errors"=>"Access denied"} and return
    end
    @voucher.bookkept_by = nil # Make sure this is not set
    @voucher.api_key = current_api_key
    if @voucher.save
      Journal.log(:api_create,@voucher,current_user, current_api_key)
    else
      raise Mage::ApiError.new("Save failed: #{@voucher.errors.inspect}")
    end
  end

  def update
    authorize! :write, resource
    params[:voucher].delete(:add_row)
    params[:voucher][:voucher_rows_attributes].each do |vr|
      if @voucher.bookkept?
        vr[:signature_id] = current_user.id if vr[:signature_id] 
      else
        vr[:signature_id] = nil #If it is not yet bookkept we shall have no signatures
      end
    end
    params[:bookkept_by] = current_user unless @voucher.bookkept?
    update! do |success, failure|
      success.html {
        if @voucher.bookkept_by_id.nil?
          @voucher.bookkept_by_id = current_user.id 
          @voucher.save
        end
        flash[:notice] = "Verifikat #{@voucher.pretty_number} har uppdaterats"
        redirect_to voucher_path(@voucher)
      }
    end
  end

  def sub_layout
    "accounting"
  end

  def print
    @vouchers = Voucher.find(:all,:conditions=>{:id=>params[:vouchers]})
    authorize! :read, @vouchers
    output = VoucherPDF.new(@vouchers).to_pdf

    respond_to do |format| 
      format.pdf do
        send_data output, :filename => "verifikat.pdf",
                          :type => :pdf,
                          :disposition=>'inline'
      end
    end
  end

  def edit
    authorize! :write, resource
    edit!
  end

  # Renders rows for new and edit
  def rows
    @voucher = Voucher.unscoped.find(:first, :conditions=>{:id=>params[:voucher_id].to_i}, :select=>[:id, :bookkept_by_id])
  
    data = params
    if data[:type] == "account"
      account = Account.find_by_number(data[:account])
      render :nothing=>true, :status=>400 and return if account.nil?
      @rows = [VoucherRow.new(:account=>account, :sum=>data[:sum].to_f, :arrangement_id=>data[:arrangement])]
    elsif data[:type] == "template"
      template = VoucherTemplate.find(data[:id])
      render :nothing=>true, :status=>400 and return if template.nil?
      @rows = template.parse({:sum=>data[:sum]},data[:arrangement])
    else
      render :nothing=>true, :status=>500 and return
    end
    @sum = @rows.reduce(0) { |memo, r| memo+=r.int_sum } 

    if @voucher &&  @voucher.bookkept? 
      @rows.each {|r| r.signature = current_user; r.updated_at = Time.now }
    end
  end

  def destroy
    @voucher = resource
    authorize! :write, @voucher
    unless @voucher.bookkept?
      @voucher.destroy
      flash[:notice] =  t 'vouchers.deleted'
    else
      flash[:error]=t 'vouchers.cant_delete_bookkept'
    end
    redirect_to accounting_index_path and return
  end

protected 
  def resource
    @voucher ||= Voucher.unscoped.find(params[:id])
    authorize! :read, @voucher
  end
end
