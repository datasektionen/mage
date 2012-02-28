require 'spec_helper'

describe VoucherTemplate do
  it "a voucher template should be valid" do
    VoucherTemplate.make.should be_valid
  end

  it "should validate stuff" do
    v = VoucherTemplate.make
    v.template_type = nil
    v.should_not be_valid
    v.template_type = VoucherTemplate::TYPE_MULTIROW
    v.name = nil
    v.should_not be_valid
  end

  it "cloning should work" do
    v = VoucherTemplate.make
    v.save

    v2 = v.clone
    old_o = v2.output_fields[0].account_number 
    old_i = v2.input_fields[0].name
    v2.save

    v.output_fields[0].account_number+=1
    v.input_fields[0].name +="foobar"
    v.save
    v2 = VoucherTemplate.find_by_id(v2.id)

    (v.output_fields.count == v2.output_fields.count).should be_true
    (v.input_fields.count == v2.input_fields.count).should be_true

    (v2.output_fields[0].account_number == old_o).should be_true

    (v2.input_fields[0].name== old_i).should be_true
  end


end
