require 'mage/reports/account_report'

describe Mage::Reports::AccountReport do
  let(:report_class) { Mage::Reports::AccountReport }
  context "generate" do
    it "must have an account param" do
      expect {
        report_class.generate
      }.to raise_error(ArgumentError)
    end

    it "accepts voucher_rows" do
      expect {
        report_class.generate(double('account').as_null_object, [stub]) 
      }.not_to raise_error(ArgumentError)
    end

    it "should create a AccountReport object" do
      account = double(name: "foobar").as_null_object
      voucher_rows = [stub(account_number: 4711)]
      report = double('report').as_null_object
      report_class.should_receive(:new).with(account, voucher_rows).and_return(report)

      report_class.generate(account, voucher_rows)
    end

    it "should call calculate_balance_difference" do
      account = double(name: "foobar").as_null_object
      voucher_rows = [stub(account_number: 4711)]
      report_class.any_instance.should_receive(:calculate_balance_difference)
      report_class.generate(account, voucher_rows)
    end

    it "should call calculate_outgoing_balance" do
      account = double(name: "foobar").as_null_object
      voucher_rows = [stub(account_number: 4711)]
      report_class.any_instance.should_receive(:calculate_outgoing_balance)
      report_class.generate(account, voucher_rows)
    end

    it "should calculate outgoing balance" do 
      account = double(name: "foobar", ingoing_balance: 4710).as_null_object
      voucher_rows = [stub(sum:-234)]
      report = report_class.generate(account, voucher_rows)
      report.outgoing_balance.should == (4710-234)
    end
  end

  context "initializer" do
    it "must have an account param" do
      expect {
        report_class.new
      }.to raise_error(ArgumentError)
    end

    it "accepts voucher_rows" do
      expect {
        report_class.new(stub, [stub]) 
      }.not_to raise_error(ArgumentError)
    end

    it "saves account" do
      account = double(name: "foobar").as_null_object
      account_report = report_class.new(account)
      account_report.account.should == account
    end

    it "saves voucher_rows" do
      voucher_rows = [stub(account_number: 4711)]
      account_report = report_class.new(double('account').as_null_object, voucher_rows)
      account_report.voucher_rows.should == voucher_rows
    end

    it "should set ingoing balance to ingoing_balance from account" do
      account = stub(ingoing_balance: 4711)
      report = report_class.new(account)
      report.ingoing_balance.should == account.ingoing_balance
    end
  end

  context "calculate_balance_difference" do 
    let(:account) { double('account').as_null_object }
    it "should set @balance_difference" do
      report = report_class.new(account,[])
      report.calculate_balance_difference
      report.balance_difference.should_not be_nil
    end

    it "should set @balance_difference to 0 for empty array" do
      report = report_class.new(account,[])
      report.calculate_balance_difference
      report.balance_difference.should == 0
    end

    it "should set @balance_difference for one element" do
      report = report_class.new(account,[stub(sum:17)])
      report.calculate_balance_difference
      report.balance_difference.should == 17
    end

    it "should aggregate the sums of the voucher_rows" do
      report = report_class.new(account,[stub(sum:17), stub(sum:23), stub(sum:-4711)])
      report.calculate_balance_difference
      report.balance_difference.should == (17+23-4711)
    end
  end
  
end
