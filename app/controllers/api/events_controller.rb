class Api::EventsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    user = currentUser
    events = user.events
    render json: { events: events }
  end

  def create
    user = currentUser
    @event = user.events.build(events_params)

    if @event.save
      @event.after_change_action
      render json: { message: 'success' }
    else
      render json: { message: 'error', errors: @event.errors }, status: 404
    end
  end

  private

  def events_params
    if params[:event][:account_or_card] == '0'
      params[:event][:card_id] = nil
    elsif params[:event][:account_or_card] == '1'
      card = Card.find_by(id: params[:event][:card_id])
      params[:event][:account_id] = card.account_id
    end
    params.require(:event).permit(
      :date, 
      :value, 
      :memo, 
      :iae, 
      :pay_date, 
      :genre_id, 
      :account_id, 
      :card_id
    )
  end

end
