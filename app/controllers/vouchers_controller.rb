class VouchersController < InheritedResources::Base

  def index
    #search
  end

  def new
    @voucher = Voucher.new
    @voucher.organ = current_serie.default_organ
  end

  def sub_layout
    "accounting"
  end

  # Renders rows for new and edit
  def rows
    data = params[:voucher][:add_row]
    if data[:type] == "account"
      account = Account.find_by_number(data[:account])
      render :nothing=>true, :status=>400 and return if account.nil?
      @rows = [VoucherRow.new(:account=>account, :sum=>data[:sum], :arrangement_id=>data[:arrangement])]
    elsif data[:type] == "template"
      #TODO: Templates
    else
      render :nothing=>true, :status=>500 and return
    end
    render :layout=>false, :partial => "form_row", :collection=>@rows and return
  end
end
