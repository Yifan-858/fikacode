Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # healthcheck route
  get '/ping', to: 'ping#show', format: :json, as: :ping

  # user route
  resources :users, only: [:create, :index, :show]

  # login route
  post '/login', to: 'session#create'

  # fika requests routes
  resources :fikas, only: [:create, :index, :show]

  # fika status only update route
  patch '/fikas/:id/update_status', to: 'fikas#update_status'

end
