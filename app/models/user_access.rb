class UserAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :series
  belongs_to :granted_by, :class_name => "User"
end
