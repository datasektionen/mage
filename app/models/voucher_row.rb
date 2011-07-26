class VoucherRow < ActiveRecord::Base
  belongs_to :voucher, :inverse_of => :voucher_rows
  belongs_to :account, :foreign_key => :account_number, :primary_key => :number
  belongs_to :arrangement
  belongs_to :signature , :class_name => "User"

  validates_presence_of  :signature, :if=>:canceled
  validates_presence_of :voucher, :sum, :account
  
  attr_readonly :account_id, :sum, :arrangement_id, :voucher_id

  def canceled?
    return canceled
  end 

  def signed?
    return (not signature.nil?)
  end

  def destroy
    raise "[VoucherRow] Tried to delete voucher_row!"
  end

  def debet
    sum >=0 ? sum : nil
  end

  def kredit
    sum < 0 ? sum : nil
  end
end
