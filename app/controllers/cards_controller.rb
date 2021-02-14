class CardsController < ApplicationController
  before_action :authenticate_user!
  
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
      flash[:danger]="クレジットカードの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    @card=Card.find_by(:user_id => params[:user_id], :id => params[:id])
    @card.destroy
    redirect_to user_cards_path(params[:user_id])
  end
  
  def show
    @card=Card.find_by(:user_id => params[:user_id], :id => params[:id])
  end
  
  def edit
    @card=Card.find_by(:user_id => params[:user_id], :id => params[:id])
  end

  def update
    @card=Card.find_by(:user_id => params[:user_id], :id => params[:id])
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
    
end
