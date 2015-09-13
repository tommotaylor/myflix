Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'static#front'

  get 'home', to: 'videos#index'
  get 'drama', to: 'categories#show'
  get 'front', to: 'static#front'
 
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]

  post 'update_queue_items', to: 'queue_items#update_queue_items'
  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]

  get 'confirm_password_reset', to: 'reset_passwords#confirm_password_reset'
  get 'invalid_token', to: 'static#invalid_token'
  resources :reset_passwords, except: [:destroy]

  resources :invites, only: [:new, :create]

  resources :categories, only: [:show, :index]
  resources :users, except: [:destroy]

  resources :videos, only: :show do
    collection do
      get :search, to: "videos#search"
      get :advanced_search, to: "videos#advanced_search"
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  mount StripeEvent::Engine, at: '/stripe_events'
end
