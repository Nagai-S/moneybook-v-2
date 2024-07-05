class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :to_explanation, only: %i[month_index show]
  before_action :correct_user!, only: %i[destroy show]

  def index
    not_order_accounts = current_user.accounts.includes(:cards)
    @accounts =
      not_order_accounts.sort { |a, b| (-1) * (a.now_value({scale: true}) <=> b.now_value({scale: true})) }
    not_order_fund_users = current_user.fund_users
    @fund_users =
      not_order_fund_users.sort { |a, b| (-1) * (a.now_value({scale: true}) <=> b.now_value({scale: true})) }
  end

  def month_index; end

  def new
    @account = current_user.accounts.build
    set_previous_url
  end

  def show
    @events =
      @account
        .events
        .where(card_id: nil)
        .includes(:account, :card, :genre)
        .page(params[:event_page])
        .per(30)
    ax_array = []
    @account
      .account_exchanges_source
      .where(card_id: nil)
      .each { |ax| ax_array.push(ax) }
    @account.account_exchanges_to.each { |ax| ax_array.push(ax) }
    @axs =
      Kaminari
        .paginate_array(ax_array.sort { |a, b| (-1) * (a.date <=> b.date) })
        .page(params[:ax_page])
        .per(30)
    @fund_user_histories = @account.fund_user_histories.where(card_id: nil)
      .page(params[:fuh_page])
      .per(30)
  end

  def create
    @account = current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to_previou_url
    else
      flash.now[:danger] = 'アカウントの作成に失敗しました。'
      render 'new'
    end
  end

  def update
    @account = current_user.accounts.find(params[:id])
    if @account.update(name: params[:account][:name])
      render json: { status: 'success' }
    else
      render json: { status: 'error' }
    end
  end

  def destroy
    index
    if @account.destroy
      redirect_to accounts_path
    else
      flash.now[:danger] = 'このアカウントに連携したクレジットカードが存在するため削除できません。'
      render 'index'
    end
  end

  private

  def accounts_params
    params.require(:account).permit(:name, :value, :currency_id)
  end

  def correct_user!
    @account = Account.find_by(id: params[:id])
    redirect_to root_path unless current_user == @account.user
  end
end
