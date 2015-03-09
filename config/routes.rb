Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root 'pages#front'
  
  get 'home', to: 'videos#index'
  
  resources :videos, only: [:show] do 
    resources :reviews, only: [:create]
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]

  get 'register', to: "users#new"
  resources :users, only: [:create]
  
  get 'sign_in', to: 'sessions#new'
  delete 'sign_out', to: 'sessions#destroy'
  resources :sessions, only: [:create]

end
