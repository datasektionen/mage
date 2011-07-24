require 'spec_helper'

describe Voucher do
  it "works" do
    voucher = Voucher.make
    voucher.should be_valid
  end
end
