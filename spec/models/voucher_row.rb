
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
end
