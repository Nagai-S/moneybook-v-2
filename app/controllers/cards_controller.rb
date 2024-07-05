class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!, only: %i[destroy edit update show pay_not_data]
  before_action :to_explanation, only: %i[show index new]
  before_action :set_previous_url, only: %i[new edit]

  def index
    @cards = current_user.cards.includes(:account)
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build(cards_params)
    if @card.save
      redirect_to_previou_url
    else
      flash.now[:danger] = 'クレジットカードの作成に失敗しました。'
      render 'new'
    end
  end

  def destroy
    index
    if @card.destroy
      redirect_to cards_path
    else
      flash.now[:danger] = 'このカードを使用した未引き落としのものが存在するため削除できません。'
      render 'index'
    end
  end

  def show
    @events =
      @card
        .events
        .includes(:account, :card, :genre)
        .page(params[:event_page])
        .per(30)
    @axs = @card.account_exchanges.page(params[:ax_page]).per(30)
    @fund_user_histories = @card.fund_user_histories.page(params[:fuh_page]).per(30)
  end

  def pay_not_data; end

  def edit; end

  def update
    if @card.update(cards_params)
      redirect_to_previou_url
    else
      flash.now[:danger] = 'クレジットカードの編集に失敗しました。'
      render 'edit'
    end
  end

  private

  def cards_params
    params.require(:card).permit(:name, :pay_date, :month_date, :account_id)
  end

  def correct_user!
    @card = Card.find_by(id: params[:id])
    redirect_to root_path unless current_user == @card.user
  end
end
