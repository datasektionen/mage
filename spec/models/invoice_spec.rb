require 'spec_helper'

describe Invoice do
  
  it "should be vaild" do
    invoice = Invoice(:invoice).make
    invoice.should be_valid
    invoice.save.should be_true
  end

  it "has an voucher" do
    Invoice(:invoice).make.vouchers.should_not be_empty
  end
end
