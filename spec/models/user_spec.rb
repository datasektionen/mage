require 'spec_helper'

describe User do
  it "should handle has_access_to?" do
    user = User.make; user.save
    serie = Serie.make; serie.save

    user.has_access_to?(serie).should be_false

    user.admin = true
    user.has_access_to?(serie).should be_true

    user.admin = false
    user_access = UserAccess.make(:user => user, :serie => serie); user_access.save
    user.reload.has_access_to?(serie).should be_true

    user_access.destroy
    user.reload.has_access_to?(serie).should be_false
  end
end