class UsersController < InheritedResources::Base 
  load_and_authorize_resource
  skip_load_and_authorize_resource only: :index

  def index
    authorize! :read, @users
    super
  end

  def update 
    add_right = params[:user][:add_right]
    unless add_right[:series].empty?
      UserAccess.create(
        :user_id=>@user.id,
        :series_id=>add_right[:series],
        :granted_by_id=>current_user.id)
    end
    params[:user].delete(:add_right)

    update! { edit_user_path(@user) }
  end

protected

  def collection
    @users ||= end_of_association_chain.order("first_name asc, last_name asc")
  end
end
