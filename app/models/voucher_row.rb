class VoucherRow < ActiveRecord::Base
  belongs_to :voucher
  belongs_to :account
  belongs_to :arrangement
  belongs_to :changed_by, :class_name => "User", :foreign_key => :changed_by

  def canceled?
    return canceled
  end 
end
