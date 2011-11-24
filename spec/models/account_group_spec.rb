require 'spec_helper'

describe AccountGroup do

  it "a account group should be valid" do
    account_group = AccountGroup.make
    account_group.should be_valid
  end

  it "should not be possible to create one without all attributes" do
    account_group = AccountGroup.make
    account_group.title = nil
    account_group.should_not be_valid
    account_group = AccountGroup.make
    account_group.account_type = nil
    account_group.should_not be_valid
    account_group.account_type = 1
    account_group.activity_year_id = nil
    account_group.should_not be_valid
  end
end
