Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#index'
  get 'video', to: 'videos#show'
  get 'drama', to: 'categories#show'
  get 'front', to: 'static#front'
 
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  delete 'sign_out', to: 'sessions#destroy'

  resources :users, except: :delete

  resources :videos, only: :show do
    collection do
      get :search, to: "videos#search"
    end
  end


end
