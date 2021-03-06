Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  # routes for static pages
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  # routes for users controller
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
  
  # routes for login
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # routes for account activation
  resources :account_activations, only: [:edit]
  
  # routes for password reset
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  # resources for microposts
  resources :microposts, only: [:create, :destroy]
end
