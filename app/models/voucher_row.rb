# -*- encoding: utf-8 -*-
class VoucherRow < ActiveRecord::Base
  belongs_to :voucher, :inverse_of => :voucher_rows
  belongs_to :account, :foreign_key => :account_number, :primary_key => :number
  belongs_to :arrangement
  belongs_to :signature , :class_name => "User"

  validates_presence_of :signature, :if=>:canceled
  validates_presence_of :voucher, :sum, :account
  validates_presence_of :arrangement, :if => Proc.new { account.has_arrangements? }
  validates_presence_of :account
  validate :no_arrangement, :unless => Proc.new { account.has_arrangements? }
  
  attr_readonly :account_number, :sum, :arrangement_id, :voucher_id

  def canceled?
    return canceled
  end 

  def signed?
    return (not signature.nil?)
  end

  def destroy
    if voucher.bookkept?
      raise "[VoucherRow] Tried to delete voucher_row from bookkept voucher!"
    else
      super
    end
  end

  def int_sum
    (sum*100.0).round
  end

  def debet
    sum >=0 ? sum : nil
  end

  def kredit
    sum < 0 ? sum.abs : nil
  end

  # Define output in log, used by Voucher.to_log
  def to_log
    "#{canceled? ? "STRUKET " : ""}#{account_number} - Arr: #{arrangement} - Summa: #{sum} #{signed? ? " - Ändrat: #{I18n.l updated_at.to_date} #{signature.initials}" : ""}"
  end

protected
  def no_arrangement
    errors[:arrangement]<< "Får inte ha arrangemang" unless arrangement.nil? && arrangement_id.nil?
  end
end
