class Motorista::RotasController < ApplicationController
  before_action :authenticate_user!
  before_action :require_motorista

  layout 'motorista'

  def index
    # Mostra pacotes associados a este motorista que estão em rota (tanto simuladas quanto normais)
    @packages = Package.where(driver_id: current_user.id).em_rota.order(created_at: :desc)
    @alertas = TrackingEvent.joins(:package).where(packages: { driver_id: current_user.id }, tracking_events: { status: 'alerta' }).order(created_at: :desc).limit(5)
  end

  def avancar
    if params[:package_id].present?
      @packages = Package.where(driver_id: current_user.id, id: params[:package_id]).em_rota
    else
      @packages = Package.where(driver_id: current_user.id).em_rota
    end

    if @packages.empty?
      redirect_to motorista_rotas_path, alert: "Nenhuma rota ativa para avançar."
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
                 when 'Processando' then "Carga consolidada e preparada para transporte pelo motorista."
                 when 'em_transito' then "Veículo conduzido pelo motorista em trânsito interestadual para #{package.regiao}."
                 when 'em rota'     then "Motorista chegou à filial de #{package.regiao} e saiu para entrega final."
                 when 'Entregue'    then "Entrega efetuada com sucesso pelo motorista em #{package.regiao}."
                 end

          package.tracking_events.create!(
            status: new_status,
            descricao: desc,
            localizacao: new_status == 'Processando' ? "Centro de Distribuição" : package.regiao
          )

          # 20% de chance de gerar um alerta de incidência (somente se não foi entregue ainda)
          if new_status != 'Entregue' && rand < 0.20
            alertas = [
              { tipo: "Atraso Crítico", msg: "Veículo parado em congestionamento ou fiscalização." },
              { tipo: "Problema Mecânico", msg: "Alerta de painel ativado. Verificação mecânica rápida." },
              { tipo: "Mudança de Rota", msg: "Rota recalculada devido a interdição na pista." },
              { tipo: "Condição Climática", msg: "Chuva pesada forçando redução de velocidade." },
              { tipo: "Entrega Tentada", msg: "Destinatário indisponível. Tentativa registrada." }
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

    msg = "Rota avançada com sucesso!"
    msg += " #{incidents_count} novo(s) alerta(s) de incidência gerado(s)." if incidents_count > 0
    redirect_to motorista_rotas_path, notice: msg
  end

  private

  def require_motorista
    unless current_user.motorista?
      redirect_to root_path, alert: "Acesso restrito apenas a motoristas."
    end
  end
end
