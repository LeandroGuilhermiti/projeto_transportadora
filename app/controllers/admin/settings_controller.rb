class Admin::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  layout 'admin'

  def index
    # Nada pesado por enquanto. Vamos utilizar current_user na View diretamente.
  end

  private

  def check_admin
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.admin?
  end
end
