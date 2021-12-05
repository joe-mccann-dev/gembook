Rails.application.routes.draw do
  get 'likes/create'
  devise_for :users
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :create] do
    resources :likes, only: [:create, :index]
  end
  resources :notifications, only: [:index, :update]
  resources :friendships, only: [:create, :update]
  root to: 'posts#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

def is_my_favorite?(hash_array)
  favorite = nil
  hash_array.each do |hash|
    favorite = hash if hash.value?(true)
  end
  favorite
end
  
