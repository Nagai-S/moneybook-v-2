class Api::AccountExchangesController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    user = currentUser
    axs = user.account_exchanges
    render json: { axs: axs }
  end

  def create
    user = currentUser
    @ax = user.account_exchanges.build(ax_params)

    if @ax.save
      @ax.after_change_action
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
    params.require(:account_exchange).permit(
      :date, 
      :value, 
      :pay_date, 
      :to_id,
      :source_id,
      :card_id
    )
  end
end
