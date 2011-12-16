require 'spec_helper'

describe Account do
  
  it "should have arrangement if account group has_arrangement" do

  end

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
end
