class Admin::RotasController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  layout 'admin'

  def index
    @packages = Package.where.not(driver_id: nil).em_rota.order(created_at: :desc)
    @entregas_disponiveis = Package.where.not(driver_id: nil).where(status: 'Pendente').order(created_at: :desc)
    @alertas = TrackingEvent.where(status: 'alerta').order(created_at: :desc).limit(5)
  end

  def iniciar
    if params[:package_id].blank?
      redirect_to admin_rotas_path, alert: "Erro ao iniciar simulação: Selecione uma entrega válida."
      return
    end

    package = Package.find(params[:package_id])
    package.update!(status: 'Processando')

    package.tracking_events.create!(
      status: 'Processando',
      descricao: "Simulação Iniciada: Carga consolidada no CD. Rota iniciada até #{package.regiao}.",
      localizacao: "Centro de Distribuição"
    )
    
    redirect_to admin_rotas_path, notice: "Rota simulada da entrega #{package.codigo_rastreio} iniciada com sucesso!"
  end

  def avancar
    @packages = Package.where.not(driver_id: nil).where(status: ['Processando', 'em_transito', 'em rota'])

    if @packages.empty?
      redirect_to admin_rotas_path, alert: "Nenhuma rota simulada ativa para avançar."
      return
    end

    incidents_count = 0

    ActiveRecord::Base.transaction do
      @packages.each do |package|
        old_status = package.status || 'Pendente'
        new_status = case old_status
                     when 'Pendente'      then 'Processando'
                     when 'Processando'   then 'em_transito'
                     when 'em_transito'   then 'em rota'
                     when 'em rota'       then 'Entregue'
                     else 'Entregue'
                     end

        if new_status != old_status
          package.update!(status: new_status)

          desc = case new_status
                 when 'Processando' then "Carga consolidada e preparada para transporte no Centro de Distribuição."
                 when 'em_transito' then "Veículo em deslocamento interestadual rumo a #{package.regiao}."
                 when 'em rota'     then "Veículo chegou à filial regional. Objeto saiu para entrega ao destinatário."
                 when 'Entregue'    then "Entrega realizada com sucesso em #{package.regiao}."
                 end

          package.tracking_events.create!(
            status: new_status,
            descricao: desc,
            localizacao: new_status == 'Processando' ? "Centro de Distribuição" : package.regiao
          )

          # 20% de chance de gerar um alerta de incidência (somente se não foi entregue ainda)
          if new_status != 'Entregue' && rand < 0.20
            alertas = [
              { tipo: "Atraso Crítico", msg: "Veículo parado há +45min em zona de risco." },
              { tipo: "Problema Mecânico", msg: "Alerta de pressão de pneu ativado. Desvio temporário." },
              { tipo: "Mudança de Rota", msg: "Desvio automático devido a acidente na rodovia principal." },
              { tipo: "Desvio de Fiscalização", msg: "Parada regulamentar para conferência de notas no posto fiscal." },
              { tipo: "Condição Climática", msg: "Chuvas fortes na região reduziram a velocidade do comboio." },
              { tipo: "Entrega Tentada", msg: "Destinatário ausente. Nova tentativa agendada para a próxima etapa." }
            ]
            sorteado = alertas.sample

            package.tracking_events.create!(
              status: 'alerta',
              descricao: "#{sorteado[:tipo]}: #{sorteado[:msg]}",
              localizacao: package.regiao
            )
            incidents_count += 1
          end
        end
      end
    end

    msg = "Simulação avançada com sucesso!"
    msg += " #{incidents_count} novo(s) alerta(s) de incidência gerado(s)." if incidents_count > 0
    redirect_to admin_rotas_path, notice: msg
  end

  def limpar
    # Apenas reseta o histórico das entregas para que possam ser simuladas de novo
    Package.where.not(driver_id: nil).find_each do |package|
      if package.tracking_events.any?
        package.tracking_events.destroy_all
        package.update(status: 'Pendente')
      end
    end
    redirect_to admin_rotas_path, notice: "Histórico de todas as simulações resetado com sucesso."
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
    end
  end
end
