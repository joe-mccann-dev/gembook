Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create]
  resources :notifications, only: [:index, :update]
  resources :friendships, only: [:create, :update]
  root to: 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
