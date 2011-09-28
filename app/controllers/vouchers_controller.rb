# -*- encoding: utf-8 -*-
class VouchersController < InheritedResources::Base 
  actions :all, :except => [:destroy]
  after_filter LogFilter , :only=>[:create,:update, :api_create]

  def index
    @vouchers = Voucher.search(params[:search], current_activity_year, current_user)
  end

  def new
    @voucher = Voucher.new
    @voucher.organ = current_serie.default_organ || Organ.first
    @voucher.serie = current_serie
    @voucher.activity_year = current_activity_year
    last_voucher = Voucher.where(:serie_id=>current_serie.id).last
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
    create!(:notice => "Verifikat #{@voucher.pretty_number} skapades") { new_voucher_path }
  end

  def api_create
    serie = Serie.find_by_letter(params[:serie])
    if serie.nil?
      render :status=>500, :json=> {'status'=> 0, "msg"=>"Invalid serie"} and return
    end
    @voucher = Voucher.new(params[:voucher])
    @voucher.serie = serie
    begin
      authorize! :write, @voucher
    rescue CanCan::AccessDenied
      render :status=>403, :json => {'status'=>0, "msg"=>"Access denied"} and return
    end
    @voucher.bookkept_by = nil # Make sure this is not set
    @voucher.api_key = current_api_key
    if @voucher.save
      render :json => { 'status'=> 1 }
    else
      render :status=>500, :json=> {'status'=> 0, "msg"=>"Save failed: #{@voucher.errors.inspect}"}
    end
  end

  def update
    params[:voucher].delete(:add_row)
    params[:voucher][:voucher_rows_attributes].each do |vr|
      vr[:signature_id] = current_user.id if vr[:signature_id] 
    end
    authorize! :write, resource
    logger.debug(params[:voucher].inspect)
    update!(:notice => "Verifikat #{@voucher.pretty_number} har uppdaterats") { voucher_path(@voucher) }
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
    @signature = (params[:voucher_id].to_i>0)
  
    data = params
    if data[:type] == "account"
      account = Account.find_by_number(data[:account])
      render :nothing=>true, :status=>400 and return if account.nil?
      @rows = [VoucherRow.new(:account=>account, :sum=>data[:sum].to_f, :arrangement_id=>data[:arrangement])]
    elsif data[:type] == "template"
      template = VoucherTemplate.find(data[:id])
      render :nothing=>true, :status=>400 and return if template.nil?
      @rows = template.parse({:sum=>data[:sum].to_f},data[:arrangement])
    else
      render :nothing=>true, :status=>500 and return
    end
    @sum = @rows.reduce(0) { |memo, r| memo+=r.sum } 
  end

protected 
  def resource
    @voucher ||= end_of_association_chain.find(params[:id])
    authorize! :read, @voucher
  end
end
