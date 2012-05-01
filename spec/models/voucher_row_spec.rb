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

  it "should not allow removal of cancellation" do
    voucher = Voucher.make
    voucher.save

    user = User.make
    user.save

    voucher.voucher_rows[0].signature = user
    voucher_row = voucher.voucher_rows[0].clone
    voucher.voucher_rows[0].canceled = true
    voucher.voucher_rows << voucher_row

    voucher.save.should be_true

    voucher.voucher_rows[0].canceled = false
    voucher.voucher_rows[0].signature = user
    voucher.voucher_rows.last.canceled = true

    voucher.should_not be_valid
  end

  it "should allow arrangements inside the organ" do
    voucher = Voucher.make
    voucher.should be_valid
  end

  it "should not allow arrangements outside the organ" do
    voucher = Voucher.make
    voucher.voucher_rows[0].arrangement = Arrangement.make(:organ=>Organ.make)
    voucher.should_not be_valid
  end

  it "should allow invalid arrangements outside the organ on cancelled rows" do
    voucher = Voucher.make
    voucher.save
    voucher_row = voucher.voucher_rows[0].clone
    voucher_row.signature = User.make
    voucher.voucher_rows << voucher_row
    voucher.voucher_rows[0].canceled = true
    voucher.voucher_rows[0].signature = User.make

    voucher.should be_valid 

    voucher.voucher_rows[0].arrangement = Arrangement.make(:organ=>Organ.make)

    voucher.should be_valid



  end

end
