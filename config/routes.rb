Beeline::Application.routes.draw do

  devise_for :users

  get 'home' => 'pages#home'
  get 'landing' => 'pages#landing'
  get 'about' => 'pages#about'
  get 'faq' => 'pages#faq'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'

  get 'contact' => 'contact#new'
  post 'contact' => 'contact#create'

  resources :brands do
    resources :products
  end

  resources :products, only: [ :index, :show, :destroy ]

  namespace :admin do
    resources :users, only: [ :index, :update, :destroy ]
  end

  namespace :api do
    resources :registrations, only: [ :create ]
  end

  root :to => 'pages#landing'

end
