# -*- encoding: utf-8 -*-
class VouchersController < InheritedResources::Base
  actions :all
  after_filter LogFilter, only: [:create, :update, :destroy]

  def index
    # Display all vouchers if params[:per] < 0
    per_page = params[:per].to_i < 0 ? Voucher.count : params[:per]

    params[:search] ||= {}
    params[:search][:activity_year_id] ||= current_activity_year.id

    @search = Voucher.search do
      with(:activity_year_id, search_param(:activity_year_id))
      with(:series_id, search_param(:series_id)) unless search_param(:series_id).blank?
      with(:organ_id, search_param(:organ_id)) unless search_param(:organ_id).blank?

      keywords(search_param(:title)) unless search_param(:title).blank?

      paginate page: params[:page], per_page: per_page
    end
    @vouchers = @search.results
  end

  def new
    @voucher = Voucher.new
    @voucher.organ = current_series.default_organ || Organ.first
    @voucher.series = current_series
    @voucher.activity_year = current_activity_year
    last_user_voucher = current_user.vouchers.where(series_id: current_series.id, activity_year_id: current_activity_year.id).last
    last_voucher = Voucher.where(series_id: current_series.id, activity_year_id: current_activity_year.id).last
    if last_user_voucher
      @voucher.accounting_date = last_user_voucher.accounting_date
      @voucher.organ = last_user_voucher.organ
    elsif last_voucher
      @voucher.accounting_date = last_voucher.accounting_date
      @voucher.organ = last_voucher.organ
    else
      @voucher.accounting_date = Time.now
    end

    authorize! :write, @voucher

    if params[:correct]
      @voucher.corrects = Voucher.find(params[:correct])
      @voucher.organ = @voucher.corrects.organ
      @voucher.voucher_rows = @voucher.corrects.inverted_rows
      @voucher.accounting_date = @voucher.corrects.accounting_date
      @voucher.title = "Rättar #{@voucher.corrects}"
      @voucher.series = @voucher.corrects.series
      @voucher.activity_year = @voucher.corrects.activity_year
      self.current_series = @voucher.series
      self.current_activity_year = @voucher.activity_year
    end
  end

  def create
    params[:voucher].delete(:add_row)
    @voucher = Voucher.new(params[:voucher])
    authorize! :write, @voucher
    if !current_api_key
      @voucher.bookkept_by = current_user
      @voucher.set_number!
    else
      @voucher.bookkept_by = nil
      @voucher.api_key = current_api_key
    end
    @voucher.material_from = current_user
    create! do |success, _failure|
      success.html do
        self.current_series = @voucher.series
        flash[:notice] = "Verifikat <a href='#{voucher_path(@voucher)}'>#{@voucher.pretty_number}</a> skapades"
        redirect_to new_voucher_path
      end
    end
  end

  def complete
    if current_api_key.nil?
      @vouchers = Voucher.unscoped.find(:all, conditions: { id: params[:vouchers] })
      authorize! :write, @vouchers
      @vouchers.each do |v|
        unless v.bookkept?
          v.bookkept_by = current_user
          v.created_at = Time.now
          if v.save
            Journal.log(:complete, v, current_user, nil)
          end
        end
      end
      flash[:notice] = t 'vouchers.bookkept_plural'
    end
    redirect_to accounting_index_path
  end

  def api_create
    unless params[:voucher]
      fail Mage::ApiError, 'Voucher data missing'
    end
    params[:voucher][:series] = Series.find_by_letter(params[:voucher][:series])
    if params[:voucher][:series].nil?
      fail Mage::ApiError, 'Invalid series letter'
    end

    unless params[:voucher][:organ]
      params[:voucher][:organ] = params[:voucher][:series].default_organ
    else
      params[:voucher][:organ] = Organ.find_by_number(params[:voucher][:organ])
      if params[:voucher][:organ].nil?
        fail Mage::ApiError, 'Invalid organ number'
      end
    end
    if params[:voucher][:activity_year]
      params[:voucher][:activity_year] = ActivityYear.find_by_year(params[:voucher][:activity_year])
    else
      fail Mage::ApiError, 'Missing activity year'
    end

    begin
      params[:voucher][:authorized_by] = User.find_or_create_by_ugid(params[:voucher][:authorized_by]) if params[:voucher][:authorized_by]
      params[:voucher][:material_from] = User.find_or_create_by_ugid(params[:voucher][:material_from]) if params[:voucher][:material_from]

      # Parse arrangement number to id
      # params[:voucher][:arrangement]
      params[:voucher][:voucher_rows_attributes].each do |vr|
        vr[:arrangement] = params[:voucher][:organ].arrangements.find_by_number(vr[:arrangement]) if vr[:arrangement]
        vr[:arrangement] = nil unless Account.find_by_number_and_activity_year_id(vr[:account_number], params[:voucher][:activity_year].id).has_arrangements?
      end

      @voucher = Voucher.new(params[:voucher])
    rescue => e
      raise Mage::ApiError, e.to_s
    end

    begin
      authorize! :write, @voucher
    rescue CanCan::AccessDenied
      return render(status: 403, json: { 'errors' => 'Access denied' })
    end
    @voucher.bookkept_by = nil # Make sure this is not set
    @voucher.api_key = current_api_key
    if @voucher.save
      Journal.log(:api_create, @voucher, current_user, current_api_key)
    else
      fail Mage::ApiError, "Save failed: #{@voucher.errors.inspect}"
    end
  end

  def update
    authorize! :write, resource
    params[:voucher].delete(:add_row)
    params[:voucher][:voucher_rows_attributes].each do |vr|
      if @voucher.bookkept?
        # Detect changes:
        voucher_row = @voucher.voucher_rows.find_by_id(vr[:id])
        if voucher_row
          voucher_row.attributes = vr
          # Add signature if row changed
          vr[:signature_id] = current_user.id if voucher_row.changed?
        else
          # New row, add signature
          vr[:signature_id] = current_user.id
        end
      else
        vr[:signature_id] = nil # If it is not yet bookkept we shall have no signatures
      end
    end

    if @voucher.bookkept?
      update_created_at = false
    else
      params[:bookkept_by] = current_user
      update_created_at = true
    end

    update! do |success, _failure|
      success.html do
        # If the voucher came from the api and was bookept now, update created at
        if update_created_at
          @voucher.created_at = Time.now
          @voucher.save
        end

        if @voucher.bookkept_by_id.nil?
          @voucher.bookkept_by_id = current_user.id
          @voucher.save
        end
        flash[:notice] = "Verifikat #{@voucher.pretty_number} har uppdaterats"
        redirect_to voucher_path(@voucher)
      end
    end
  end

  def sub_layout
    'accounting'
  end

  def print
    @vouchers = Voucher.find(:all, conditions: { id: params[:vouchers] })
    authorize! :read, @vouchers
    output = VoucherPDF.new(@vouchers).to_pdf

    respond_to do |format|
      format.pdf do
        send_data output, filename: 'verifikat.pdf',
                          type: :pdf,
                          disposition: 'inline'
      end
    end
  end

  def edit
    authorize! :write, resource
    edit!
  end

  # Renders rows for new and edit
  def rows
    @voucher = Voucher.unscoped.find(:first, conditions: { id: params[:voucher_id].to_i }, select: [:id, :bookkept_by_id])

    @activity_year = params[:activity_year]

    if params[:type] == 'account'
      account = Account.find_by_number_and_activity_year_id(params[:account], params[:activity_year])
      return render(nothing: true, status: 400) if account.nil?
      @rows = [VoucherRow.new(account: account, sum: params[:sum].to_f, arrangement_id: params[:arrangement])]
    elsif params[:type] == 'template'
      template = VoucherTemplate.find(params[:id])
      return render(nothing: true, status: 400) if template.nil?
      @rows = template.parse({ sum: params[:sum] }, params[:arrangement], params[:activity_year])
    else
      return render(nothing: true, status: 500)
    end
    @sum = @rows.map(&:int_sum).reduce(0, :+)

    if @voucher && @voucher.bookkept?
      @rows.each { |r| r.signature = current_user; r.updated_at = Time.now }
    end
  end

  def destroy
    @voucher = resource
    authorize! :write, @voucher
    unless @voucher.bookkept?
      @voucher.destroy
      flash[:notice] =  t 'vouchers.deleted'
    else
      flash[:error] = t 'vouchers.cant_delete_bookkept'
    end
    return redirect_to(accounting_index_path)
  end

  protected

  def resource
    @voucher ||= Voucher.unscoped.find(params[:id])
    authorize! :read, @voucher
  end

  private

  def search_param(name)
    params[:search].try(:[], name.to_s)
  end
end
