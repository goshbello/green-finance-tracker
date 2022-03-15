Rails.application.routes.draw do

  resources :user_stocks
  devise_for :users
  root 'welcome#index'

  # routes to display stock information in browser
  get 'portfolio', to: 'users#portfolio'

  #search for stock route
  get 'search_stock', to: 'stocks#search'










  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
