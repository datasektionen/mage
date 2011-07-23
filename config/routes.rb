Mage::Application.routes.draw do
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"} do
    get "sign_in", :to => "users/omniauth_callbacks#new", :as => :new_user_session
    get "sign_out", :to => "users/omniauth_callbacks#destroy", :as => :destroy_user_session
  end

  localized(['sv']) do 

    resources :journals
    resources :series
    resources :users
    resources :reports
    resources :vouchers, :except => :destroy do 
      collection do
        post :search
        get :rows, :defaults => {:format => :xml}
      end
    end

    resources :accounts do
      collection do
        get :search, :defaults => {:format => :json}
      end
    end
    
    resources :administration, :only => [:index], :controller => "administration"
    resources :accounting, :only => [:index], :controller => "accounting" do
      collection do
        post :index
      end
    end

    resources :bank_accounting, :only => [:index, :update, :show, :create, :destroy], :controller => :bank_accounting

    root :to => "welcome#index"
  end

end
