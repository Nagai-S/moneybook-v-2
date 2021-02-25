class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :to_explanation, only: :month_index
  
  def index
    current_user.make_sure_pay_date_and_pon
    @accounts=current_user.accounts
  end

  def month_index
  end

  def new
    @account=current_user.accounts.build
  end

  def create
    @account=current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to user_accounts_path
    else
      flash.now[:danger]="アカウントの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    @account=Account.find_by(:user_id => params[:user_id], :id => params[:id])
    index
    if @account.cards.exists?
      flash.now[:danger]="このアカウントに連携したクレジットカードが存在するため削除できません"
      render "index"
    elsif @account.account_exchanges.exists? 
      flash.now[:danger]="このアカウントを使用した振り替えがあるため削除できません。"
      render "index"
    else
      @account.destroy
      redirect_to user_accounts_path
    end
  end
  
  private
    def accounts_params
      params.require(:account).permit(:name, :value)
    end
    
end
