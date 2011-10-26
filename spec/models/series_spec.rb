require 'spec_helper'

describe Series do
  it "should handle accessible_by?" do
    user = User.make; user.save
    serie = Series.make; serie.save

    serie.accessible_by?(user).should be_false

    user.admin = true
    serie.accessible_by?(user).should be_true

    user.admin = false
    user_access = UserAccess.make(:user => user, :serie => serie); user_access.save
    serie.accessible_by?(user.reload).should be_true

    user_access.destroy
    serie.accessible_by?(user.reload).should be_false
  end
end
