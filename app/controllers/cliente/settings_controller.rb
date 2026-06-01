module Cliente
  class SettingsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_cliente!
    layout "cliente"

    def index
      # Configurações do cliente (exibe a tela usando o current_user)
    end

    private

    def require_cliente!
      redirect_to root_path, alert: "Acesso não autorizado." unless current_user&.cliente?
    end
  end
end
