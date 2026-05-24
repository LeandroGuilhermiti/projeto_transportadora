class TrackingController < ApplicationController
  def index
  end

  def search
    @package = Package.find_by(codigo_rastreio: params[:codigo_rastreio])
  end

  def status
    @package = Package.find_by(codigo_rastreio: params[:codigo_rastreio])
    if @package
      render json: {
        status: @package.status,
        updated_at: @package.updated_at,
        tracking_events: @package.tracking_events.order(created_at: :desc).map { |e|
          { status: e.status, descricao: e.descricao, localizacao: e.localizacao, created_at: e.created_at }
        }
      }
    else
      render json: { error: "Pacote não encontrado" }, status: :not_found
    end
  end
end
