Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get 'about', to: 'pages#about'
  get 'watchlist', to: 'pages#watchlist'
  get 'portfolio', to: 'pages#portfolio'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
