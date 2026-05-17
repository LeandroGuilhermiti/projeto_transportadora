class Admin::DriversController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @motoristas = User.where(cargo: 'motorista').order(created_at: :desc)

    @total_motoristas = @motoristas.count
    @motoristas_em_rota = @motoristas.joins(:packages).where(packages: { status: 'Em Rota' }).distinct.count
    @motoristas_disponiveis = @total_motoristas - @motoristas_em_rota
  end
end
