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
    resources :drivers, only: [:index, :new, :create]

    # Acompanhar Rotas — Admin (acesso total)
    get  "rotas",          to: "rotas#index",   as: "rotas"
    post "rotas/iniciar",  to: "rotas#iniciar", as: "rotas_iniciar"
    post "rotas/avancar",  to: "rotas#avancar", as: "rotas_avancar"
    post "rotas/limpar",   to: "rotas#limpar",  as: "rotas_limpar"
  end

  namespace :cliente do
    get "dashboard", to: "dashboard#index", as: "dashboard"
    get "historico", to: "historico#index", as: "historico"
    get "settings", to: "settings#index", as: "settings"
    resources :entregas, only: [:new, :create, :show]
  end

  # Acompanhar Rotas — Motorista (visualizar + avançar suas próprias rotas)
  namespace :motorista do
    get  "rotas",         to: "rotas#index",   as: "rotas"
    post "rotas/avancar", to: "rotas#avancar", as: "rotas_avancar"
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
