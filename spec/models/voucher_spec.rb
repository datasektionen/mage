require 'spec_helper'

describe Voucher do

  it "should be valid" do
    voucher = Voucher.make
    voucher.should be_valid
  end

  it "should enforce sum == 0" do
    voucher = Voucher.make
    voucher.should be_valid

    voucher.voucher_rows.first.sum = 100
    voucher.voucher_rows.last.sum = 200

    voucher.should_not be_valid
  end

  it "should not allow voucher row destruction on bookkept voucher" do
    voucher = Voucher.make
    voucher_rows = voucher.voucher_rows
    voucher.save

    lambda {voucher.voucher_rows.first.destroy}.should raise_error()

    voucher.voucher_rows.should == voucher_rows

   params = {}

    params[:voucher_rows_attributes] = [
      {
        :id=>voucher.voucher_rows[0].id,
        :_destroy=>true
      },
      {
        :id=>voucher.voucher_rows[1].id,
        :_destroy=>true
      }
    ]
    lambda { voucher.update_attributes params}.should raise_error()


    lambda { voucher.save }.should raise_error()

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
    voucher.voucher_rows[0].account.save
    voucher.save

    r = VoucherRow.new(voucher.voucher_rows[0].attributes)
    r.signature = User.make
    voucher.voucher_rows << r
    voucher.voucher_rows[0].canceled = true
    voucher.voucher_rows[0].signature = User.make
    voucher.should be_valid

    voucher.voucher_rows[0].signature = nil
    voucher.should_not be_valid
  end

  it "should not enforce signatures on added rows on not bookkept (in update)" do
    voucher = Voucher.make(:not_bookkept)
    voucher.save
    voucher_rows = voucher.voucher_rows

    voucher.bookkept_by = User.make

    sum = rand(100)
    added_rows = [
      VoucherRow.make(:voucher => voucher, :sum => sum),
      VoucherRow.make(:voucher => voucher, :sum => -sum)
    ]
    voucher.voucher_rows << added_rows
    voucher.should be_valid

  end

  it "should not allow change of most attributes series, number,activity_year bookkept_by" do
    voucher = Voucher.make
    voucher.should be_valid
    voucher.save
    
    pre = voucher.attributes
    ++voucher.number
    voucher.bookkept_by = User.make
    voucher.activity_year = ActivityYear.make
    voucher.save
    voucher = Voucher.find(voucher.id)

    post = voucher.attributes
    post[:created_by_id].should == pre[:created_by_id]
    post[:activity_year_id].should == pre[:activity_year_id]
  end

  describe "that has stagnated" do
    before(:each) do
      @voucher = Voucher.make
      @voucher.created_at = (Mage::Application.settings[:voucher_stagnation_time]+1).minutes.ago
      @voucher.save
    end

    it "stagnated? should return true" do
      @voucher.stagnated?.should be_true
    end


    it "should not allow change of accounting date" do 
      @voucher.accounting_date = 2.days.ago
      @voucher.should_not be_valid
    end

    it "should not allow change of series" do 
      series = Series.make
      series.save
      @voucher.series = series
      @voucher.should_not be_valid
    end

    it "should not allow change of organ" do 
      organ = Organ.make
      organ.save
      @voucher.organ = organ
      @voucher.should_not be_valid
    end
  end

  describe "fresh voucher" do
    before(:each) do
      @voucher = Voucher.make
      @voucher.created_at = (Mage::Application.settings[:voucher_stagnation_time]-1).minutes.ago
      @voucher.save
    end

    it "should allow change of accounting date" do 
      @voucher.accounting_date = 2.days.ago
      @voucher.should be_valid
    end

    it "should allow change of organ" do 
      organ = Organ.make
      organ.save
      @voucher.organ = organ
      # We must cancel all rows and add new with this organ
      user = User.make
      user.save
      new_rows = []
      @voucher.voucher_rows.each do |vr|
        new_vr = vr.clone
        new_vr.signature = user
        new_vr.arrangement = Arrangement.make(:organ=>organ)
        vr.signature = user
        vr.cancel!
        new_rows << new_vr
      end

      @voucher.voucher_rows.push *new_rows

      @voucher.should be_valid
    end

    it "should allow change of series" do 
      series = Series.make
      series.save
      @voucher.series = series
      @voucher.should be_valid
    end
  end

  it "should not allow empty vouchers" do
    voucher = Voucher.make
    voucher.voucher_rows = []
    voucher.should_not be_valid
  end

  it "should allow not bookkept vouchers" do
    voucher = Voucher.make(:not_bookkept); voucher.save
    voucher.should be_valid
  end

  it "should allow deletion of not bookkept vouchers" do
    voucher = Voucher.make(:not_bookkept); voucher.save
    voucher.destroy
  end

  it "should allow row adding without signature in not bookkept vouchers" do
    voucher = Voucher.make(:not_bookkept); 
    voucher.save
    sum = rand(100)
    voucher.bookkept_by = User.make
    added_rows = [
      VoucherRow.make(:voucher => voucher, :sum => sum),
      VoucherRow.make(:voucher => voucher, :sum => -sum)
    ]
    voucher.voucher_rows << added_rows
    voucher.should be_valid
  end

  it "should allow row deletion in not bookkept vouchers" do
    voucher = Voucher.make(:not_bookkept); 
    sum = rand(100)
    added_rows = [
      VoucherRow.make(:voucher => voucher, :sum => sum),
      VoucherRow.make(:voucher => voucher, :sum => -sum)
    ]
    voucher.voucher_rows << added_rows
    voucher.save
    voucher.voucher_rows.drop(2)
    voucher.should be_valid
    voucher.save
    voucher.voucher_rows << added_rows
    voucher.save

    num_rows = voucher.voucher_rows.count

    params = {}

    params[:bookkept_by_id] = User.make.id #One should be able to set bookkept in this request
    params[:voucher_rows_attributes] = [
       {
         :id=>voucher.voucher_rows[0].id,
         :_destroy=>true
       },
       {
         :id=>voucher.voucher_rows[1].id,
         :_destroy=>true
       }
     ]

    voucher.update_attributes params

    voucher.save
  end

  it "should allow row deletion and addition in not bookkept vouchers" do
    voucher = Voucher.make(:not_bookkept); 
    voucher.save

    num_rows = voucher.voucher_rows.count

    params = {}

    params[:bookkept_by_id] = User.make.id #One should be able to set bookkept in this request
    params[:voucher_rows_attributes] = [
       {
         :id=>voucher.voucher_rows[0].id,
         :_destroy=>true
       },
       {
          :account=>Account.make(:account_group=>AccountGroup.make(:account_type=>1)),
          :sum=>voucher.voucher_rows[0].sum
       }
     ]
    voucher.update_attributes params
    voucher.should be_valid
    voucher.save

    voucher.voucher_rows.count.should == num_rows

  end

  it "should not be possible to set a date outside the activity year" do
    voucher = Voucher.make
    voucher.accounting_date = voucher.accounting_date - 1.year
    voucher.should_not be_valid
  end
end
