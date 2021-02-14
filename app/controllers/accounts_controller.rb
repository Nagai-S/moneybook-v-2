class AccountsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @accounts=current_user.accounts
  end

  def new
    @account=current_user.accounts.build
  end

  def create
    @account=current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to user_accounts_path
    else
      flash[:danger]="アカウントの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    @account=Account.find_by(:user_id => params[:user_id], :id => params[:id])
    a=true
    # current_user.credits.each do |credit|
    #   if credit.account==@account.name
    #     a=false
    #     break
    #   end
    # end
    if a
      @account.destroy
      redirect_to user_accounts_path
    else
      flash[:danger]="このアカウントに連携したクレジットカードが存在するためこのアカウントは削除できません"
      redirect_to user_accounts_path
    end
  end
  
  private
    def accounts_params
      params.require(:account).permit(:name, :value)
    end
    
end
