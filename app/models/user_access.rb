class UserAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :serie
  belongs_to :granted_by, :class => "User"
end