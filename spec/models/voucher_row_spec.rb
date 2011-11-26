require 'spec_helper'

describe VoucherRow do
  it "readonly attributes" do
    vr = VoucherRow.make
    vr.save
    
    pre = vr.attributes
    vr.account = Account.make
    vr.sum+=100
    vr.arrangement = Arrangement.make
    vr.voucher = Voucher.make
    vr.save
    vr = VoucherRow.find(vr.id)

    post = vr.attributes
    post[:account_number].should == pre[:account_number]
    post[:sum].should == pre[:sum]
    post[:arrangement_id].should == pre[:arrangement_id]
    post[:voucher_id].should == pre[:voucher_id]

  end

  it "should enforce precence of arrangments on needed voucher_rows" do
    voucher = Voucher.make
    (3..4).each do |i|
      voucher.voucher_rows[0].account.account_group.account_type = i
      voucher.voucher_rows[0].account.has_arrangements?.should == true
      voucher.voucher_rows[0].arrangement = Arrangement.make
      voucher.should be_valid 
      voucher.voucher_rows[0].arrangement = nil
      voucher.should_not be_valid 
    end
  end

  it "should enforce absence of arrangements on needed voucher_rows" do
    voucher = Voucher.make
    (1..2).each do |i|
      voucher.voucher_rows[0].account.account_group.account_type = i
      voucher.voucher_rows[0].account.has_arrangements?.should == false
      voucher.voucher_rows[0].arrangement = nil
      voucher.should be_valid 
      voucher.voucher_rows[0].arrangement = Arrangement.make
      voucher.should_not be_valid 
    end
  end
end
