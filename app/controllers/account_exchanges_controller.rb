class AccountExchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :to_explanation, only: %i[index new]
  before_action :correct_user!, only: %i[destroy edit update]
  before_action :set_previous_url, only: %i[new edit]

  def index
    @axs =
      current_user
        .account_exchanges
        .includes(:account, :card, :to_account)
        .page(params[:ax_page])
  end

  def new
    @ax = current_user.account_exchanges.build
  end

  def create
    @ax = current_user.account_exchanges.build(ax_params)

    if @ax.save
      redirect_to_previou_url
    else
      flash.now[:danger] = '振替の作成に失敗しました。'
      render 'new'
    end
  end

  def destroy
    @ax.destroy
    redirect_to_referer
  end

  def edit; end

  def update
    if @ax.update(ax_params)
      redirect_to_previou_url
    else
      flash.now[:danger] = '振替の編集に失敗しました。'
      render 'edit'
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

  def correct_user!
    @ax = AccountExchange.find_by(id: params[:id])
    redirect_to root_path unless current_user == @ax.user
  end
end
