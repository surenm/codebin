Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'auth'}

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout",:to => "devise/sessions#destroy"
    get "signup",:to => "devise/registrations#new"
  end

  get "/users/sign_in" => redirect("/login")
  get "/users/sign_up" => redirect("/signup")
  get "/users"         => redirect("/signup")


  root to: "home#index"
end
