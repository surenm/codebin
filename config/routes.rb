require "resque_web"

Rails.application.routes.draw do
  # Users management
  devise_for :users, :controllers => { :omniauth_callbacks => 'auth'}
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout",:to => "devise/sessions#destroy"
    get "signup",:to => "devise/registrations#new"
  end
  get "/users/sign_in" => redirect("/login")
  get "/users/sign_up" => redirect("/signup")
  get "/users"         => redirect("/signup")

  # Admin user management
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Worker queue interface
  mount ResqueWeb::Engine => "/queue"
  ResqueWeb::Engine.eager_load!

  # Rest api for snippets
  resources :snippets

  # Rest api for games
  resources :games

  # Application Root
  root to: "snippets#new"
end