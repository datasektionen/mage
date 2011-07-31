class UserAccess < ActiveRecord::Base
  belongs_to :user
  belongs_to :serie
  belongs_to :granted_by, :class_name => "User"

  def write_access?
    write_access
  end
end
