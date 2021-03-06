require 'spec_helper'

describe AccountGroup do
  it 'a account group should be valid' do
    account_group = AccountGroup.make
    account_group.should be_valid
  end

  it 'should not be possible to create one without all attributes' do
    account_group = AccountGroup.make
    account_group.title = nil
    account_group.should_not be_valid
    account_group = AccountGroup.make
    account_group.account_type = nil
    account_group.should_not be_valid
    account_group.account_type = 1
    account_group.number = nil
    account_group.should_not be_valid
  end

  it 'should be possible to delete an unused account group' do
    ag = AccountGroup.make
    (ag.destroy == ag).should be_true
    AccountGroup.find_by_id(ag.id).should be_nil
  end

  it 'should not be allowed to destroy an used account group' do
    ag = AccountGroup.make
    a = Account.make
    ag.accounts << a
    ag.save

    ag.allow_destroy?.should be_false
    lambda { ag.destroy }.should raise_error
    AccountGroup.find_by_id(ag.id).should_not be_nil
    Account.find_by_id(a.id).should_not be_nil
  end
end
