module Cliente
  class HistoricoController < ApplicationController
    before_action :authenticate_user!
    before_action :require_cliente!
    layout "cliente"

    def index
      # Filtra pacotes do cliente cujo status seja Entregue (case insensitive na medida do possível, ou exato 'Entregue')
      @entregas_entregues = current_user.client_packages
                                        .where("LOWER(status) = ?", 'entregue')
                                        .order(updated_at: :desc)
    end

    private

    def require_cliente!
      redirect_to root_path, alert: "Acesso não autorizado." unless current_user&.cliente?
    end
  end
end
