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
    
    @alertas_criticos = TrackingEvent.where(status: 'alerta').count
    @despachos_prioritarios = Package.where(status: 'Pendente').order(created_at: :asc).limit(5)
    
    # Carrega pacotes dinâmicos em trânsito/rota para renderizar no mapa do dashboard
    @packages_em_rota = Package.em_rota.order(created_at: :desc)
    
    # Carrega alertas recentes do simulador para a barra lateral
    @alertas = TrackingEvent.where(status: 'alerta').order(created_at: :desc).limit(3)
  end
end
