Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'sessions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/notifications', to: 'users#notifications'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :edit, :update, :destroy]
  resources :conversations, only: [:create, :index, :show]
  resources :messages, only: [:create]
  resources :blocks, only: [:create, :destroy, :index]
  resources :reports, only: [:create]

  get '/names', to: 'users#names'


  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :account_activations, only: [:edit]

  resources :microposts,          only: [:create, :destroy, :update]

  resources :relationships,       only: [:create, :destroy]

  get 'microposts/tags/:name', to: 'microposts#tags', as: 'tags'
end
