module Cliente
  class EntregasController < ApplicationController
    before_action :authenticate_user!
    before_action :require_cliente!
    layout "cliente"

    def new
      @package = Package.new
    end

    def create
      @package = Package.new(package_params)
      @package.status = "Processando"

      if @package.save
        redirect_to cliente_dashboard_path,
                    notice: "✅ Entrega solicitada com sucesso! Código: #{@package.codigo_rastreio}"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def package_params
      params.require(:package).permit(:destinatario, :endereco, :regiao, :peso, :dimensoes)
    end

    def require_cliente!
      redirect_to root_path, alert: "Acesso não autorizado." unless current_user&.cliente?
    end
  end
end
