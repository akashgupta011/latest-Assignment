Rails.application.routes.draw do

  get "/user/show", to: "users#show"
  post "/users/register", to: "users#registeration"
  post "/users", to: "users#login"
  patch "/user/update", to: "users#update"
  delete "/user/logout", to: "users#log_out"
  delete "/user/remove", to: "users#remove_user"

end
