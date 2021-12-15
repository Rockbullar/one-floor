Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get 'about', to: 'pages#about'
  get 'watchlist', to: 'pages#watchlist'
  get 'landing', to: 'pages#landing'
  post 'addcollectionwatchlist', to: 'pages#add_collection_to_watchlist'
  get 'portfolio', to: 'pages#portfolio'
  get 'updatesearch', to: 'pages#update_search'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
