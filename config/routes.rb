# config/routes.rb
# This file defines the routing configuration for the application.

Rails.application.routes.draw do
  # User routes
  get "/user/show", to: "users#show"
  get "/users/filter", to: "users#filter"
  post "/users/register", to: "users#registration"
  post "/users", to: "users#login"
  patch "/user/update", to: "users#update"
  delete "/user/logout", to: "users#log_out"
  delete "/user/remove", to: "users#remove_user"

  # Admin routes for controlling admin access
  get "/comments", to: "comments#index"
  delete "/admin/delete/user/:id", to: "users#admin_remove"
  delete "/admin/delete/post/:id", to: "posts#admin_remove"
  delete "/admin/comment/:id", to: "comments#admin_remove"

  # Nested resources for posts and comments
  resources :posts do
    resources :comments
  end

  # Custom routes for post filtering and searching
  get "post/filter", to: "posts#filter"
  get "post/search", to: "posts#search"

  # Resources for categories and tags
  resources :categories, only: [:create, :index]
  resources :tags, only: [:create, :index]
end
