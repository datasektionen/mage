class VouchersController < InheritedResources::Base

  def index
      @vouchers = Voucher.search(params[:search], current_activity_year)
  end

  def new
    @voucher = Voucher.new
    @voucher.organ = current_serie.default_organ
    @voucher.serie = current_serie
    @voucher.activity_year = current_activity_year
  end

  def create
    params[:voucher].delete(:add_row)
    @voucher = Voucher.new(params[:voucher])
    @voucher.set_number!
    @voucher.created_by = current_user
    create!(:notice => "Verifikat #{@voucher.pretty_number} skapades") { new_voucher_path }
  end

  def sub_layout
    "accounting"
  end

  def print
    @vouchers = Voucher.find(:all,:conditions=>{:id=>params[:vouchers]})
    output = VoucherPDF.new(@vouchers.first).to_pdf
    #output = VoucherPDF.new.to_pdf

    respond_to do |format| 
      format.pdf do
        send_data output, :filename => "verifikat.pdf",
                          :type => "application/pdf",
                          :disposition=>'inline'
      end
    end
  end

  # Renders rows for new and edit
  def rows
    data = params
    if data[:type] == "account"
      account = Account.find_by_number(data[:account])
      render :nothing=>true, :status=>400 and return if account.nil?
      @rows = [VoucherRow.new(:account=>account, :sum=>data[:sum], :arrangement_id=>data[:arrangement])]
    elsif data[:type] == "template"
      #TODO: Templates
    else
      render :nothing=>true, :status=>500 and return
    end
    @sum = @rows.reduce(0) { |memo, r| memo+=r.sum } 
  end
end
