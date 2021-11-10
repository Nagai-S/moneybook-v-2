class AccountExchangesController < ApplicationController
  before_action :authenticate_user!
  before_action :to_explanation, only: [:index, :new]
  before_action :correct_user!, only: [:destroy, :edit, :update]
  before_action :set_previous_url, only: [:new, :edit]
  
  def index
    @axs = current_user
    .account_exchanges
    .includes(:account,:card,:to_account)
    .page(params[:ax_page])
  end

  def new
    @ax = current_user.account_exchanges.build
  end

  def create
    @ax = current_user.account_exchanges.build(ax_params)
    association_model_update

    if @ax.save
      @ax.after_change_action
      redirect_to_previou_url
    else
      flash.now[:danger] = "振替の作成に失敗しました。"
      render "new"
    end
  end

  def destroy
    @ax.destroy
    if @ax.destroy
      unless Rails.env.test?
        redirect_to request.referer
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = "エラーが発生しました。ブラウザをリロードしてやり直してください"
      unless Rails.env.test?
        redirect_to request.referer 
      else
        redirect_to root_path 
      end
    end
  end

  def edit
  end

  def update
    association_model_update
    if @ax.update(ax_params)
      @ax.after_change_action
      redirect_to_previou_url
    else
      flash.now[:danger] = "振替の編集に失敗しました。"
      render "edit"
    end
  end
  
  private
    def ax_params
      params.require(:account_exchange).permit(:date, :value, :pay_date)
    end    

    def association_model_update
      @ax.to_id = params[:account_exchange][:to_account]
      if params[:account_exchange][:account_or_card] == "0"
        @ax.source_id = params[:account_exchange][:source_account]
        @ax.card_id = nil
      elsif params[:account_exchange][:account_or_card] == "1"
        @ax.card_id = params[:account_exchange][:card]
        @ax.source_id = nil
      end
    end
    
    def correct_user!
      @ax = AccountExchange.find_by(id: params[:id])
      redirect_to root_path unless current_user == @ax.user
    end
    
end
