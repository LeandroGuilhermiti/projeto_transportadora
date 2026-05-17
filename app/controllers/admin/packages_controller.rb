class Admin::PackagesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso restrito apenas a administradores."
      return
    end

    @packages = Package.all.order(created_at: :desc)
  end
end
