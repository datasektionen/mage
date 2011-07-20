class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def new
    redirect_to person_omniauth_authorize_path(:cas)
  end

  def cas
    @user= User.find_for_cas_oath(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "CAS"
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_url
    end
  end

  def destroy
    sign_out_and_redirect current_user
  end
end
