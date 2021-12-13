Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get 'about', to: 'pages#about'
<<<<<<< HEAD
  get 'watchlist', to: 'pages#watchlist'
=======
  get 'landing', to: 'pages#landing'
>>>>>>> e503c87 (marquee-less landing page)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
