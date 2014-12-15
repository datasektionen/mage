require 'spec_helper'

describe Account do
  it 'should validate uniquness of number in year' do
    a = Account.make
    a.save
    b = Account.make
    b.number = a.number
    b.activity_year_id = a.activity_year_id
    b.should_not be_valid
  end

  it 'should be possible to delete an unused account' do
    a = Account.make
    a.save
    a.allow_destroy?.should be_true
    a.destroy.should_not be_false
    Account.find_by_id(a.id).should be_nil
  end

  it 'should not be allowed to destroy an used account' do
    a = Account.make
    a.save
    v = Voucher.make
    v.voucher_rows.first.account_number = a.number
    v.activity_year_id = a.activity_year_id
    v.save

    a.allow_destroy?.should be_false
    a.destroy.should be_false
    Account.find_by_id(a.id).should_not be_nil
  end

  it 'should require obligatory fields' do
    a = Account.make
    a.name = nil
    a.should_not be_valid
    a = Account.make
    a.number = nil
    a.should_not be_valid
    a = Account.make
    a.account_group = nil
    a.should_not be_valid
    a = Account.make
    a.activity_year = nil
    a.should_not be_valid
  end

  it 'should not be allowed to change number in used account' do
    a = Account.make
    a.save
    v = Voucher.make
    v.voucher_rows.first.account_number = a.number
    v.activity_year_id = a.activity_year_id
    v.save.should be_true

    a.number += 10_000

    a.should_not be_valid
  end
end
