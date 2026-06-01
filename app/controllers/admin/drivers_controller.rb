class Admin::DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  layout 'admin'

  def index
    @motoristas = User.where(cargo: 'motorista').order(created_at: :desc)

    @total_motoristas    = @motoristas.count
    @motoristas_em_rota  = @motoristas.joins(:packages).where(packages: { status: 'Em Rota' }).distinct.count
    @motoristas_disponiveis = @total_motoristas - @motoristas_em_rota
  end

  def new
    @motorista = User.new
  end

  def create
    @motorista = User.new(driver_params)
    @motorista.cargo = 'motorista'

    if @motorista.save
      redirect_to admin_drivers_path, notice: "Motorista #{@motorista.nome} cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def driver_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation, :regiao_atuacao)
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
    end
  end
end
