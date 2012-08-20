require 'spec_helper'

describe Invoice do
  
  it "should be vaild" do
    invoice = Invoice.make
    invoice.should be_valid
    invoice.save.should be_true
  end
  it "has an voucher" do
    Invoice.make.voucher.should_not be_nil
  end

  it "should get account types correct" do
    invoice = Invoice.make(:outgoing)
    invoice.sum_account_type.should eq(Account::ASSET_ACCOUNT)
    invoice = Invoice.make(:ingoing)
    invoice.sum_account_type.should eq(Account::DEBT_ACCOUNT)
  end
  
  it "the blueprints should set correct account types" do
    invoice = Invoice.make(:outgoing)
    invoice.voucher.voucher_rows[0].account.account_type.should eq(invoice.sum_account_type)
    invoice = Invoice.make(:ingoing)
    invoice.voucher.voucher_rows[0].account.account_type.should eq(invoice.sum_account_type)
  end

  it "calculates a simple sum correct" do
    invoice = Invoice.make(:outgoing)
    invoice.save
    # Verify
    invoice.voucher.voucher_rows[0].account.account_type.should eq(invoice.sum_account_type)
    invoice.sum.should eq(invoice.voucher.voucher_rows[0].sum.abs)
  end
end
