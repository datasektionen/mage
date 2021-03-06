Mage::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } do
    get 'sign_in', to: 'users/omniauth_callbacks#new', as: :new_user_session
    get 'sign_out', to: 'users/omniauth_callbacks#destroy', as: :destroy_user_session
  end

  localized(['sv']) do
    resources :journals
    resources :series
    resources :users
    resources :organs
    resources :arrangements, only: [:create, :new, :edit, :update, :show]

    resources :account_groups

    resources :activity_years do
      resources :accounts, except: [:create, :new, :edit, :update] do
        collection do
          get :search, defaults: { format: :json }
          get :edit
          put :edit, action: :update
        end
      end
    end

    resources :reports, only: :index do
      collection do
        post :show
      end
    end
    resources :vouchers do
      collection do
        get :rows, defaults: { format: :xml }
        post :print, default: { format: :pdf }
        get :print, default: { format: :pdf }
        post :complete
        get :complete
        post :api_create, defaults: { format: :json }
      end
    end

    resources :administration, only: [:index], controller: 'administration'
    resources :accounting, only: [:index], controller: 'accounting' do
      collection do
        post :index
        get :navigate
      end
    end

    resources :voucher_templates do
      collection do
        get :fields
        post :parse
      end
      member do
        get :clone
      end
    end

    get '404', to: 'errors#error_404', as: :error_404
    get '401', to: 'errors#error_401', as: :error_401

    resources :api_keys

    resources :bank_accounting, only: [:index, :update, :show, :create, :destroy], controller: :bank_accounting

    root to: 'welcome#index'
  end
end
