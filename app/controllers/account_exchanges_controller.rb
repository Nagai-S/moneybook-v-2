class AccountExchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :select_ax, only: [:destroy, :edit, :update]
  before_action :to_explanation, only: [:index, :new]
  
  def index
    @axs=current_user.account_exchanges.page(params[:page])
  end

  def new
    @ax=current_user.account_exchanges.build
  end

  def create
    @ax=current_user.account_exchanges.build(ax_params)
    association_model_update

    if @ax.save
      @ax.after_change_action(@ax.pay_date)
      redirect_to user_account_exchanges_path(current_user)
    else
      flash.now[:danger]="振替の作成に失敗しました。"
      render "new"
    end
  end

  def destroy
    before_source_inf=@ax.before_change_action
    before_to_inf=@ax.before_change_for_toAccount
    @ax.destroy
    before_source_inf[:account].plus(before_source_inf[:value])
    before_to_inf[:account].plus(before_to_inf[:value])
    redirect_to user_account_exchanges_path(current_user)
  end
  
  def edit
  end

  def update
    before_source_inf=@ax.before_change_action
    before_to_inf=@ax.before_change_for_toAccount
    association_model_update
    if @ax.update(ax_params)
      before_source_inf[:account].plus(before_source_inf[:value])
      before_to_inf[:account].plus(before_to_inf[:value])
      @ax.after_change_action(@ax.pay_date)
      redirect_to user_account_exchanges_path(current_user)
    else
      flash.now[:danger]="振替の編集に失敗しました。"
      render "new"
    end
  end
  
  private
    def ax_params
      params.require(:account_exchange).permit(:date, :value, :pay_date)
    end    

    def select_ax
      @ax=AccountExchange.find_by(:user_id => params[:user_id], :id => params[:id])
    end

    def association_model_update
      @ax.update(to_id: params[:account_exchange][:to_account])
      if params[:account_exchange][:account_or_card]=="0"
        @ax.update(source_id: params[:account_exchange][:source_account], card_id: nil)
      elsif params[:account_exchange][:account_or_card]=="1"
        @ax.update(card_id: params[:account_exchange][:card], source_id: nil)
      end
    end
    
end
