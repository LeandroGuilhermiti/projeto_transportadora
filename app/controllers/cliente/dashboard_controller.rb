module Cliente
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_cliente!
    layout "cliente"

    def index
      @entregas = current_user.packages.order(created_at: :desc)
      @total_em_transito = @entregas.where(status: ['em_transito', 'em rota', 'em_rota']).count
      @previsao_hoje     = @entregas.where(status: ['em_transito', 'em rota', 'em_rota']).count
      @principais_rotas  = @entregas.select(:regiao).distinct.count
    end

    private

    def require_cliente!
      redirect_to root_path, alert: "Acesso não autorizado." unless current_user&.cliente?
    end
  end
end
