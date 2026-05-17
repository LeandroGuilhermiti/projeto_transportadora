Rails.application.routes.draw do
  root "tracking#index"
  post "tracking/search", to: "tracking#search", as: "tracking_search"

  resources :packages
  resources :vehicles
  devise_for :users

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :packages, only: [:index]
    resources :drivers, only: [:index]
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
