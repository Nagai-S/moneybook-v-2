class Api::AccountExchangesController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    axs = @user.account_exchanges
    render json: { axs: axs }
  end

  def create
    @ax = @user.account_exchanges.build(ax_params)

    if @ax.save
      render json: { message: 'success' }
    else
      render json: { message: 'error', errors: @ax.errors }, status: 404
    end
  end

  private

  def ax_params
    if params[:account_exchange][:account_or_card] == '0'
      params[:account_exchange][:card_id] = nil
    elsif params[:account_exchange][:account_or_card] == '1'
      card = Card.find_by(id: params[:account_exchange][:card_id])
      params[:account_exchange][:source_id] = card.account_id
    end
    
    source_account = current_user.accounts.find_by(id: params[:account_exchange][:source_id])
    params[:account_exchange][:source_currency_id] = source_account.currency_id

    to_account = current_user.accounts.find_by(id: params[:account_exchange][:to_id])
    params[:account_exchange][:to_currency_id] = to_account.currency_id

    params.require(:account_exchange).permit(
      :date, 
      :value, 
      :to_value,
      :pay_date, 
      :to_id,
      :source_id,
      :card_id,
      :source_currency_id,
      :to_currency_id
    )
  end
end
