class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_person!
  skip_before_filter :verify_user!

  def new
    redirect_to user_omniauth_authorize_path(:cas)
  end

  def cas
    @user= User.find_for_cas_oath(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_path
    end
  end

  def destroy
    sign_out_and_redirect current_user
  end
end
