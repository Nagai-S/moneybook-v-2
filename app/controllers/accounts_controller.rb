class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :to_explanation, only: :month_index
  before_action :correct_user!, only: :destroy
  
  def index
    not_order_accounts = current_user.accounts.includes(:cards)
    @accounts = not_order_accounts.sort{|a, b| (-1) * (a.now_value <=> b.now_value)}
    @fund_users = current_user.fund_users
    assets_array = []
    @accounts.each do |account|
      assets_array.push([omit_string(account.name), account.now_value])
    end
    @fund_users.each do |fund_user|
      assets_array.push([omit_string(fund_user.fund.name), fund_user.now_value])
    end
    @assets_ratio = assets_array.sort{|a, b| (-1) * (a[1] <=> b[1])}
  end

  def month_index
  end

  def new
    @account = current_user.accounts.build
    set_previous_url
  end

  def create
    @account = current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to_previou_url
    else
      flash.now[:danger] = "アカウントの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    index
    if @account.cards.exists?
      flash.now[:danger] = "このアカウントに連携したクレジットカードが存在するため削除できません"
      render "index"
    else
      @account.before_destroy_action
      @account.destroy
      redirect_to accounts_path
    end
  end
  
  private
    def accounts_params
      params.require(:account).permit(:name, :value)
    end

    def correct_user!
      @account = Account.find_by(id: params[:id])
      redirect_to root_path unless current_user == @account.user
    end
    
end
