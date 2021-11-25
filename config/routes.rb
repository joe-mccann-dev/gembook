Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resource :friendships, only: [:create]
  root to: 'users#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
