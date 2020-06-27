Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "items#index"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/register", to: "users#new"

  get "/profile", to: "profile#show"
  patch "/profile", to: "profile#show"
  get "/profile/edit", to: 'profile#edit'
  get "/profile/edit_password", to: 'profile#edit_password'
  get "/profile/orders", to: 'user/orders#index'
  get "/profile/orders/:order_id", to: "user/orders#show"

  get "/logout", to: "welcome#index"



  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  resources :reviews, only: [:edit, :update, :destroy]


  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  put "/cart/:item_id", to: "cart#update_quantity"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
  patch "/orders/:order_id", to: "orders#update"

  patch "/item_orders/:item_order_id", to: "item_orders#update"

  namespace :admin do
    get "/", to: "orders#index"
    get "/users", to: "users#index"
    get "/merchants/:merchant_id", to: "merchant_dashboard#index"
    get "/users/:id", to: "users#show"
    patch "/orders/:id/ship", to: "orders#ship"
    get "/merchants", to: "merchants#index"
    patch "/merchants/:merchant_id", to: "merchants#update"
  end

  namespace :merchant do
    get '/', to: "dashboard#index"
    get '/orders/:id', to: "orders#show"
    resources :items, only: [:index, :update]
  end

  resources :users, only: [:create, :update]

end
