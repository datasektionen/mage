require 'spec_helper'

describe Arrangement do
  it "should validate presence correctly" do
    arr = Arrangement.make
    arr.should be_valid
    arr.number = nil
    arr.should_not be_valid
    arr = Arrangement.make
    arr.name = nil
    arr.should_not be_valid
    arr = Arrangement.make
    arr.organ = nil
    arr.should_not be_valid
  end

  it "should validate uniqueness of number" do
    a1 = Arrangement.make
    a2 = Arrangement.make
    a2.save
    a3 = Arrangement.make

    a2.organ = Organ.make
    a2.save

    # Pre test check:
    (a1.organ_id == a2.organ_id).should_not be_true

    a1.number = a2.number
    a1.should be_valid
    a2.should be_valid
    a1.save

    a3.organ_id = a1.organ_id
    a3.number = a1.number+1000
    a3.should be_valid
    a3.number = a1.number

    a3.should_not be_valid
  end

  it "year scoping should work" do
    arr = Arrangement.make
    arr.save
    Arrangement.in_year(2011).any? {|a| a == arr }.should be_true
    arr.in_year?(2011).should be_true
    arr.valid_from = 2008
    arr.save
    Arrangement.in_year(2008).any? {|a| a == arr }.should be_true
    arr.in_year?(2008).should be_true
    Arrangement.in_year(2011).any? {|a| a == arr }.should be_true
    arr.in_year?(2011).should be_true
    Arrangement.in_year(2007).any? {|a| a == arr }.should_not be_true
    arr.in_year?(2007).should_not be_true
    arr.valid_to = 2011
    arr.save
    Arrangement.in_year(2011).any? {|a| a == arr }.should be_true
    arr.in_year?(2011).should be_true
    Arrangement.in_year(2010).any? {|a| a == arr }.should be_true
    arr.in_year?(2010).should be_true
    Arrangement.in_year(2008).any? {|a| a == arr }.should be_true
    arr.in_year?(2008).should be_true
    Arrangement.in_year(2007).any? {|a| a == arr }.should_not be_true
    arr.in_year?(2007).should_not be_true
    Arrangement.in_year(2012).any? {|a| a == arr }.should_not be_true
    arr.in_year?(2012).should_not be_true
  end

  it "should not be allowed to set valid dates on arrangement num 0" do
    arr = Arrangement.make
    arr.number = 0
    arr.should be_valid
    arr.valid_to = 2011
    arr.should_not be_valid
    arr.valid_to = nil
    arr.valid_from = 2008
    arr.should_not be_valid
  end

  it "should be allowed to set valid dates on arrangement with num != 0" do
    arr = Arrangement.make
    arr.number += 1000
    arr.should be_valid
    arr.valid_to = 2011
    arr.should be_valid
    arr.valid_to = nil
    arr.valid_from = 2008
    arr.should be_valid
  end
end
