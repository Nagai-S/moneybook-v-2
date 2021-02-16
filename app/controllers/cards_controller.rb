class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :select_card, only: [:destroy, :edit, :update, :show,]
  
  def index
    @cards=current_user.cards
  end

  def new
    @card=current_user.cards.build
  end

  def create
    @card=current_user.cards.build(cards_params)
    @card.update(account_id: params[:card][:account])
    if @card.save
      redirect_to user_cards_path
    else
      flash.now[:danger]="クレジットカードの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    @card.destroy
    redirect_to user_cards_path(params[:user_id])
  end
  
  def show
  end
  
  def edit
  end

  def update
    if @card.update(cards_params)
      redirect_to user_cards_path(params[:user_id])
    else
      flash.now[:danger]="ジャンルの編集に失敗しました。"
      render "edit"
    end
  end
  
  private
    def cards_params
      params.require(:card).permit(:name, :pay_date, :month_date)
    end

    def select_card
      @card=Card.find_by(:user_id => params[:user_id], :id => params[:id])
    end
    
end
