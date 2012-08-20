require 'spec_helper'

describe Invoice do
  it "has an voucher" do
    Invoice.make.voucher.should_not be_nil
  end
end
