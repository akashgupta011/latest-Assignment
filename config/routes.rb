Rails.application.routes.draw do

  get "/user/show", to: "users#show"
  post "/users/register", to: "users#registeration"
  post "/users", to: "users#login"
  patch "/user/update", to: "users#update"
  delete "/user/logout", to: "users#log_out"
  delete "/user/remove", to: "users#remove_user"

  #admin routes for controlling admin access
  get "/comments", to: "comments#index"
  delete "/admin/delete/user/:id", to: "users#admin_remove"
  delete "/admin/delete/post/:id", to: "posts#admin_remove"
  delete "/admin/comment/:id", to: "comments#admin_remove"
  
  resources :posts do
    resources :comments
  end

  get "post/filter", to: "posts#filter"
  get "post/search", to: "posts#search"

  resources :categories, only: [:create, :index]
  resources :tags, only: [:create, :index]

end
