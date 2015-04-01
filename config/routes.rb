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
  resources :users, only: [:show, :create]

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy]

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy, :update]

  get 'sign_in', to: 'sessions#new'
  delete 'sign_out', to: 'sessions#destroy'
  resources :sessions, only: [:create]

end
