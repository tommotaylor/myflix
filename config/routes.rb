Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#index'
  get 'drama', to: 'categories#show'
  get 'front', to: 'static#front'
 
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_out', to: 'sessions#destroy'

  get 'my_queue', to: 'queue_items#index'

  resources :users, except: [:destroy]

  resources :videos, only: :show do
    collection do
      get :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end


end
