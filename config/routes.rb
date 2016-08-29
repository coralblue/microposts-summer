Rails.application.routes.draw do

  root to: 'static_pages#home'
  get    'signup', to: 'users#new'
  get    'login' , to: 'sessions#new'
  post   'login' , to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get    'help', to: 'static_pages#help'
  # root to: 'static_pages#contact'
  # get    'Help', to: 'static_pages#contact'
  # root :to => 'static_pages#contact'
  
  resources :microposts
  resources :relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]

  
  resources :users do
    member do
      get 'followings'
      get 'followers'
      get 'likes'
    end
  end
end