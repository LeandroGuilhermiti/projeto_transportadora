class PackagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_package, only: %i[ show edit update destroy reset_tracking ]

  def index
    @packages = Package.where(driver_id: current_user.id).order(created_at: :desc)
  end

  def show
  end

  def new
    @package = Package.new
  end

  def edit
  end

  def create
    @package = Package.new(package_params)
    if @package.save
      if current_user.admin?
        redirect_to admin_packages_path, notice: "Pacote foi criado com sucesso."
      else
        redirect_to packages_path, notice: "Pacote foi criado com sucesso."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @package.update(package_params)
      if current_user.admin?
        redirect_to admin_packages_path, notice: "Pacote atualizado e salvo!"
      else
        redirect_to packages_path, notice: "Pacote atualizado e salvo!"
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @package.destroy
    if current_user.admin?
      redirect_to admin_packages_path, notice: "Pacote apagado com sucesso."
    else
      redirect_to packages_path, notice: "Pacote apagado com sucesso."
    end
  end

  def reset_tracking
    @package.tracking_events.destroy_all
    @package.update(status: 'Pendente')
    redirect_to package_path(@package), notice: "Histórico de rastreamento reiniciado!"
  end

  private

  def set_package
    @package = Package.find(params[:id])
  end

  def package_params
    params.require(:package).permit(:codigo_rastreio, :destinatario, :endereco, :peso, :status, :driver_id, :regiao)
  end
end
