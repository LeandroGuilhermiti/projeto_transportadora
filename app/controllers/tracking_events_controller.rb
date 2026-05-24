class TrackingEventsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @package = Package.find(params[:package_id])
    @event = @package.tracking_events.build(event_params)

    if @event.save
      @package.update(status: @event.status)
      render json: { success: true, event: @event }
    else
      render json: { success: false, errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:tracking_event).permit(:status, :descricao, :localizacao)
  end
end
