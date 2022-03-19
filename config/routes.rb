Rails.application.routes.draw do

  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root 'welcome#index'

  # routes to display stock information in browser
  get 'portfolio', to: 'users#portfolio'

   # routes to display stock information in browser
  get 'my_friends', to: 'users#my_friends'

  #search for stock route
  get 'search_stock', to: 'stocks#search'

 #search for friend route
 get 'search_friend', to: 'users#search'

 # friendship create and delete route
 resources :friendships, only: [:create, :destroy]

 # route to create user
 resources :users, only: [:show]









  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
