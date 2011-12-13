require 'spec_helper'

describe Series do
  it "should handle accessible_by?" do
    user = User.make; user.save
    series = Series.make; series.save

    series.accessible_by?(user).should be_false

    user.admin = true
    series.accessible_by?(user).should be_true

    user.admin = false
    user_access = UserAccess.make(:user => user, :series => series); user_access.save
    series.accessible_by?(user.reload).should be_true

    user_access.destroy
    series.accessible_by?(user.reload).should be_false
  end

  it "should not require name and letter" do
    series = Series.make
    series.name = nil
    series.should_not be_valid
    series.letter = nil
    series.should_not be_valid
    series.name = "derp"
    series.should_not be_valid
  end
end
