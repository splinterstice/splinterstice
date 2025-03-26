Rails.application.routes.draw do
  get "register/index"
  get "rooms/index"
  post "rooms/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  #
  # Ping
  get "/ping", to: 'ping#pong', as: 'ping'
  # Signin
  get "/signin", to: "sessions#new"
  post "/signin", to: "sessions#create"
  get "/signout", to: "sessions#destroy"
  get "/register", to: "register#index"
  post "/register", to: "register#create"
  # Room
  resources :rooms do
    resources :messages
  end
  resources :users
  root "rooms#index"

  namespace :api do
    namespace :v1 do
      # Direct Messages
      resources :messages, only: [:index, :create]
      
      # Friends Management (for sending friend requests and removal)
      resources :friends, only: [:create, :destroy]

      # Chat Rooms: join, leave, and send messages
      post 'chat_rooms/join', to: 'chat_rooms#join'
      post 'chat_rooms/leave', to: 'chat_rooms#leave'
      post 'chat_rooms/message', to: 'chat_rooms#message'

      # Administrative Endpoints
      namespace :admin do
        post 'invite', to: 'admin#invite'
        post 'promote', to: 'admin#promote'
        post 'ban', to: 'admin#ban'
        put 'edit_user', to: 'admin#edit_user'
        post 'reset_keys', to: 'admin#reset_keys'
      end
    end
  end
end
