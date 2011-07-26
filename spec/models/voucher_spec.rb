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

  it "should enforce signatures on canceled rows" do
    voucher = Voucher.make

    sum = rand(100)
    rows = [
      VoucherRow.make(:voucher => voucher, :sum => sum),
      VoucherRow.make(:voucher => voucher, :sum => -sum)
    ]
    voucher.voucher_rows = rows
    voucher.save
    
    r = VoucherRow.new(voucher.voucher_rows[0].attributes)
    r.signature = User.make
    voucher.voucher_rows << r
    voucher.voucher_rows[0].canceled = true
    voucher.voucher_rows[0].signature = User.make

    voucher.valid?
    puts voucher.errors.inspect
    voucher.should be_valid

    voucher.voucher_rows[0].signature = nil

    voucher.should_not be_valid

  end

  it "should not allow change of most attributes" do
    voucher = Voucher.make
    voucher.save
    
    pre = voucher.attributes
    ++voucher.number
    voucher.serie = Serie.make
    voucher.organ = Organ.make
    voucher.accounting_date = Time.now.years_since(1)
    voucher.created_by = User.make
    voucher.activity_year = ActivityYear.make
    voucher.save
    voucher = Voucher.find(voucher.id)

    post = voucher.attributes
    post[:serie_id].should == pre[:serie_id]
    post[:organ_id].should == pre[:organ_id]
    post[:accounting_date].should == pre[:accounting_date]
    post[:created_by_id].should == pre[:created_by_id]
    post[:activity_year_id].should == pre[:activity_year_id]

  end
end
