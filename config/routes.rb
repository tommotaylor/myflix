Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'video#index'
  get 'video', to: 'video#show'

end
