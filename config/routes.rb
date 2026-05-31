Rails.application.routes.draw do
  root "tracking#index"
  post "tracking/search", to: "tracking#search", as: "tracking_search"
  get "tracking/:codigo_rastreio/status", to: "tracking#status", as: "tracking_status"

  resources :packages do
    resources :tracking_events, only: [:create]
    member do
      post :reset_tracking
    end
  end
  resources :vehicles
  devise_for :users

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    get "settings", to: "settings#index"
    resources :packages, only: [:index, :new, :create]
    resources :entregas, only: [:index, :new, :create]
    resources :drivers, only: [:index]
  end

  namespace :cliente do
    get "dashboard", to: "dashboard#index", as: "dashboard"
    resources :entregas, only: [:new, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
