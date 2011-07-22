class VoucherRow < ActiveRecord::Base
  belongs_to :voucher
  belongs_to :account
  belongs_to :arrangement
  belongs_to :changed_by, :class => "User", :foreign_key => :changed_by

  def canceled?
    return canceled
  end 

  def arr
    return Arrangement.new(:name=>"Övrigt", :number=>0, :organ=>voucher.organ) if arrangement.nil?
    return arrangement
  end
end
