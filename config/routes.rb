Mage::Application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"} do
    get "sign_in", :to => "users/omniauth_callbacks#new", :as => :new_user_session
    get "sign_out", :to => "users/omniauth_callbacks#destroy", :as => :destroy_user_session
  end

  localized(['sv']) do 

    resources :journals
    resources :series
    resources :users

    root :to => "welcome#index"
  end

end
