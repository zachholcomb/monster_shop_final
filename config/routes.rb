Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #welcome
  get "/", to: "welcome#index"

  #merchants
  resources :merchants do
    resources :items, only: [:index, :show]
  end
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # get "/merchants/:merchant_id/items", to: "merchants_items#index"
  # get "/merchants/:merchant_id/items/:item_id", to: "merchants_items#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  #items
  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"

  #reviews
  resources :reviews, only: [:edit, :update, :destroy]
  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  #cart
  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/increase/:item_id",  to: "cart#increase_quantity"
  patch "/cart/decrease/:item_id",  to: "cart#decrease_quantity"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  #orders
  resources :orders, only: [:new, :create, :show]
  # get "/orders/new", to: "orders#new"
  # post "/orders", to: "orders#create"
  # get "/orders/:id", to: "orders#show"

  #sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  #users
  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get '/profile/password/edit', to: 'users_password#edit'
  patch '/profile/password', to: 'users_password#update'
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/orders", to: "orders#index"
  get "/profile/orders/:id", to: 'orders#show'
  patch "/profile/orders/:id", to: "item_orders#update"

  #merchant
  namespace :merchant do
    get '/dashboard', to: 'dashboard#show'
    resources :items
    # get '/items', to: 'items#index'
    # patch '/items/:id', to: 'items#update'
    # delete '/items/:id', to: 'items#destroy'
    # get '/items/new', to: 'items#new'
    # post '/items', to: 'items#create'
    # get 'items/:id/edit', to: 'items#edit'
    resources :orders, only: [:show]
    resources :item_orders, only: [:update]
    # get '/orders/:id', to: 'orders#show'
    # patch '/item_orders/:id/', to: 'item_orders#update'
    resources :discounts
  end

  #admin
  namespace :admin do
    get "/dashboard", to: "dashboard#show"
    resources :users do
      resources :orders, only: [:index], controller: 'users_orders'
      get '/password/edit', to: 'users_password#edit'
      patch '/password/edit', to: 'users_password#update'     
      # get '/orders', to: 'users_orders#index'
    end
    # get '/users', to: 'users#index'
    # get "/users/:user_id", to: "users#show"
    # get '/users/:user_id/edit', to: 'users#edit'
    # patch '/users/:user_id', to: 'users#update'
    # get '/merchants', to: 'merchants#index'
    resources :items
    resources :orders, only: [:update]
    resources :merchants do
      resources :discounts, controller: 'merchant_discounts'
      resources :items, controller: 'merchant_items'
      # get '/discounts/new', to: 'merchant_discounts#new'
      # post '/discounts', to: 'merchant_discounts#create'
      # get '/discounts/:id', to: 'merchant_discounts#show'
      # get '/discounts', to: 'merchant_discounts#index'
      # get '/discounts/:id/edit', to: 'merchant_discounts#edit'
      # patch '/discounts/:id', to: 'merchant_discounts#update'
      # delete '/discounts/:id', to: 'merchant_discounts#destroy'
      # get '/items', to: 'merchant_items#index'
      # get '/items/:id/edit', to: 'merchant_items#edit'
      # patch '/items/:id', to: 'merchant_items#update'
      # get '/items/new', to: 'merchant_items#new'
      # post '/items', to: 'merchant_items#create'
      # delete '/items/:id', to: 'merchant_items#destroy'
    end
  end
end
