class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!, only: [:destroy, :edit, :update, :show, :pay_not_data]
  before_action :to_explanation, only: [:show, :index, :new]
  before_action :set_previous_url, only: [:new, :edit]
  
  def index
    @cards = current_user.cards.includes(:account)
  end

  def new
    @card = current_user.cards.build
  end

  def create
    @card = current_user.cards.build(cards_params)
    @card.account_id = params[:card][:account]
    if @card.save
      redirect_to_previou_url
    else
      flash.now[:danger] = "クレジットカードの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    if @card.events.exists?(pon: false) || 
      @card.account_exchanges.exists?(pon: false) ||
      @card.fund_user_histories.exists?(pon: false)
      index
      flash.now[:danger] = "このカードを使用した未引き落としのものが存在するため削除できません。"
      render "index"
    else
      @card.before_destroy_action
      if @card.destroy
        redirect_to cards_path
      else
        flash.now[:danger] = "エラーが発生しました。ブラウザをリロードしてやり直してください"
        redirect_to cards_path
      end
    end
  end

  def show
    @events = @card.events
    .includes(:account,:card,:genre)
    .page(params[:event_page]).per(30)
    ax_array = []
    @card.account_exchanges.each{|ax| ax_array.push(ax)}
    @axs = Kaminari.paginate_array(ax_array)
    .page(params[:ax_page]).per(30)
    @fund_user_histories = @card.fund_user_histories
  end
  
  def pay_not_data
  end

  def edit
  end

  def update
    @card.account_id = params[:card][:account]
    if @card.update(cards_params)
      @card.after_update_action
      redirect_to_previou_url
    else
      flash.now[:danger] = "クレジットカードの編集に失敗しました。"
      render "edit"
    end
  end
  
  private
    def cards_params
      params.require(:card).permit(:name, :pay_date, :month_date)
    end

    def correct_user!
      @card = Card.find_by(id: params[:id])
      redirect_to root_path unless current_user == @card.user
    end
    
end
