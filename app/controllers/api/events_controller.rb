class Api::EventsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    events = @user.events
    render json: { events: events }
  end

  def create
    @event = @user.events.build(events_params)

    if @event.save
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

    if params[:event][:iae] == 'false'
      params[:event][:value] = -1 * (params[:event][:value].to_f.abs)
    end

    account = current_user.accounts.find_by(id: params[:event][:account_id])
    params[:event][:pay_currency_id] = account.currency_id

    currency = Currency.find(params[:event][:currency_id])
    pay_currency = Currency.find(params[:event][:pay_currency_id])
    
    if params[:event][:pay_value]
      params[:event][:pay_value] = params[:event][:iae] == 'true' ? (
        params[:event][:pay_value] 
      ) : (
        -1 * (params[:event][:pay_value].to_f.abs)
      )
    elsif params[:event][:currency_id] == params[:event][:pay_currency_id].to_s
      params[:event][:pay_value] = params[:event][:value]
    else
      params[:event][:pay_value] = params[:event][:value] * currency.scale_to(pay_currency)
    end
    

    params.require(:event).permit(
      :date, 
      :value, 
      :memo, 
      :iae, 
      :pay_date, 
      :genre_id, 
      :account_id, 
      :currency_id,
      :pay_currency_id,
      :pay_value,
      :card_id
    )
  end

end
