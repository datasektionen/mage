class VoucherRow < ActiveRecord::Base
  belongs_to :voucher
  belongs_to :account
  belongs_to :arrangement
  belongs_to :signature , :class_name => "User"

  validates :signature, :presence=>true, :if=>:canceled
  
  attr_readonly :account_id, :sum, :arrangement_id

  def canceled?
    return canceled
  end 
end
