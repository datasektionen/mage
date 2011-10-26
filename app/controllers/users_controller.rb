  class UsersController < InheritedResources::Base 
    load_and_authorize_resource

    def update 
      add_right = params[:user][:add_right]
      unless add_right[:series].empty?
        UserAccess.create(
          :user_id=>@user.id,
          :series_id=>add_right[:series],
          :write_access=>add_right[:write_access],
          :granted_by_id=>current_user.id)
    end
    params[:user].delete(:add_right)
    
    update!
  end
end
