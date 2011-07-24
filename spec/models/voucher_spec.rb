require 'spec_helper'

describe Voucher do
  it "should enforce sum == 0" do
    voucher = Voucher.make
    voucher.should be_valid

    voucher.voucher_rows.first.sum = 100
    voucher.voucher_rows.last.sum = 200

    voucher.should_not be_valid
  end

  it "should not allow voucher row destruction" do
    voucher = Voucher.make
    voucher_rows = voucher.voucher_rows

    lambda {voucher.voucher_rows.first.destroy}.should raise_error()

    voucher.voucher_rows.should == voucher_rows
  end

  it "should enforce signatures on added rows" do
    voucher = Voucher.make
    voucher.save
    voucher_rows = voucher.voucher_rows

    sum = rand(100)
    added_rows = [
      VoucherRow.make(:voucher => voucher, :sum => sum),
      VoucherRow.make(:voucher => voucher, :sum => -sum)
    ]
    lambda {voucher.voucher_rows << added_rows}.should raise_error()

    voucher.voucher_rows.should == voucher_rows
  end
end
