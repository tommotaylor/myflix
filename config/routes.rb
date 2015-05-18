Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'videos#index'
  get 'video', to: 'videos#show'
  get 'drama', to: 'categories#show'

  resources :videos, only: :show do
    collection do
      get :search, to: "videos#search"
    end
  end


end
