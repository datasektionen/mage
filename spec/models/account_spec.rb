require 'spec_helper'

describe Account do
  
  it "find_by_activity_year shall work" do
    a = Account.make
    a.save
    Account.find_by_activity_year(a.account_group.activity_year_id).include?(a).should be_true
    Account.find_by_activity_year(a.account_group.activity_year).include?(a).should be_true
  end

  it "find_by_number_and_activity_year shall work" do
    a = Account.make
    a.save
    (a == Account.find_by_number_and_activity_year(a.number, a.account_group.activity_year)).should be_true
    (a == Account.find_by_number_and_activity_year(a.number, a.account_group.activity_year_id)).should be_true
  end

  it "should be possible to delete an unused account" do
    a = Account.make
    a.save
    a.allow_destroy?.should be_true
    a.destroy.should_not be_false
    Account.find_by_id(a.id).should be_nil
  end

  it "should not be allowed to destroy an used account" do
    a = Account.make
    a.save
    v = Voucher.make
    v.voucher_rows.first.account_number = a.number
    v.activity_year_id = a.account_group.activity_year_id
    
    v.save
    a.allow_destroy?.should be_false
    a.destroy.should be_false
    Account.find_by_id(a.id).should_not be_nil
  end

  it "should require number and name" do
    a = Account.make
    a.name = nil
    a.should_not be_valid
    a = Account.make
    a.number = nil
    a.should_not be_valid
  end 

  it "should not be allowed to change number in used account" do
    a = Account.make
    a.save
    v = Voucher.make
    v.voucher_rows.first.account_number = a.number
    v.activity_year_id = a.account_group.activity_year_id
    v.save
    a.allow_destroy?.should_not be_true
  
    a.number+=1
    a.should_not be_valid
  end
end
