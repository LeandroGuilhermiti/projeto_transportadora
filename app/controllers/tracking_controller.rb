class TrackingController < ApplicationController
  def index
  end

  def search
    @package = Package.find_by(codigo_rastreio: params[:codigo_rastreio])
  end
end
