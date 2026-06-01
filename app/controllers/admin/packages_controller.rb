class Admin::PackagesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @packages = Package.all.order(created_at: :desc)

    if params[:driver_id].present?
      @motorista_filtro = User.find_by(id: params[:driver_id])
      @packages = @packages.where(driver_id: params[:driver_id]) if @motorista_filtro
    end
  end

  def new
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @package = Package.new
  end

  def create
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @package = Package.new(package_params)
    @package.status = 'Pendente'

    if @package.save
      redirect_to admin_packages_path, notice: "Pacote criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def package_params
    params.require(:package).permit(:codigo_rastreio, :destinatario, :endereco, :peso, :dimensoes, :regiao)
  end
end
