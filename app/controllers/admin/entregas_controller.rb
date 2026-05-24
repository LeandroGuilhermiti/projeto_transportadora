class Admin::EntregasController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @packages = Package.all.order(created_at: :desc)
  end

  def new
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @package = Package.new
    @pacotes_pendentes = Package.where(driver_id: nil)
    @motoristas = User.where(cargo: 'motorista')
  end

  def create
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    # Se um package_id foi selecionado, atualiza o pacote existente.
    # Caso contrário, pode ser uma falha de validação ou tentou criar do zero sem pacote.
    # A interface de "Nova Entrega" assume que estamos vinculando um pacote existente a um motorista.
    if params[:package_id].present?
      @package = Package.find(params[:package_id])
      if @package.update(entrega_params.merge(status: 'Pendente'))
        redirect_to admin_entregas_path, notice: "Entrega atribuída com sucesso!"
      else
        @pacotes_pendentes = Package.where(driver_id: nil)
        @motoristas = User.where(cargo: 'motorista')
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_admin_entrega_path, alert: "Por favor, selecione um pacote para criar a entrega."
    end
  end

  private

  def entrega_params
    params.require(:package).permit(:driver_id, :regiao)
  end
end
