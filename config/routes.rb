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

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :categories, only: [:show]

  get 'register', to: "users#new"
  resources :users, only: [:show, :create]

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirm', to: 'forgot_passwords#show'

  resources :password_resets, only: [:create, :show]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new, :create]
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy, :update]

  get 'sign_in', to: 'sessions#new'
  delete 'sign_out', to: 'sessions#destroy'
  resources :sessions, only: [:create]

  mount StripeEvent::Engine, at: '/stripe_events'

end
