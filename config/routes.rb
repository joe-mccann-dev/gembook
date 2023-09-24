Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'posts#index'
  get 'profile', to: 'users#show'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  resources :users, only: [:index, :show] do
    collection do
      get 'search', to: 'users#index'
      get 'show_other_users'
      get 'show_friends'
    end
    
    resource :profile
  end
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments
  end

  resources :comments do
    resources :likes, only: [:create, :destroy]
    resources :comments
  end

  resources :notifications, only: [:index, :update] do
    collection do
      post 'dismiss_all'
    end
  end
  resources :friendships, only: [:create, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
