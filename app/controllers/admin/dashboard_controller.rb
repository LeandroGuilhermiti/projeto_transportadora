class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @total_entregas = Package.count
    @motoristas_ativos = User.where(cargo: 'motorista').count
    
    total = @total_entregas.nonzero? || 1
    entregues = Package.where(status: 'Entregue').count
    @eficiencia = ((entregues.to_f / total) * 100).round(1)
    
    @alertas_criticos = Package.where(status: 'Pendente').count # Simplification for mock

    @despachos_prioritarios = Package.where(status: 'Pendente').order(created_at: :asc).limit(5)
  end
end
