Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'user/tickets#unassigned'
  end

  root to: 'tickets#new', as: :root_path

  resources :tickets, except: [:index, :destroy], param: :slug
  
  namespace :user do
    resources :tickets, only: [:edit, :update] do
      collection do
        get :unassigned
        get :open
        get :hold
        get :closed
        get :search
      end

      member do
        post :assign
      end
    end
  end
end
