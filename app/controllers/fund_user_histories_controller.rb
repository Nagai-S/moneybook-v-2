class FundUserHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :select_fund_user
  before_action :correct_user!, only: :destroy
  before_action :to_explanation, only: [:index, :new]
  before_action :set_previous_url, only: [:new]
  
  def index
    @fund_user_histories = @fund_user.fund_user_histories
  end

  def new
    @fund_user_history = @fund_user.fund_user_histories.build
  end

  def create
    @fund_user_history = @fund_user.fund_user_histories.build(fund_user_historys_params)
    association_model_update

    if @fund_user_history.save
      if !@fund_user_history.buy_or_sell
        @fund_user_history.value -= @fund_user_history.commission
      end
      @fund_user_history.after_change_action(@fund_user_history.pay_date)
      redirect_to_previou_url
    else
      flash.now[:danger] = @fund_user_history.buy_or_sell_name + "に失敗しました。"
      render "new"
    end
  end

  def destroy
    if !@fund_user_history.buy_or_sell
      @fund_user_history.value -= @fund_user_history.commission
    end
    if @fund_user_history.account == nil && @fund_user_history.card == nil
      @fund_user_history.destroy
    else
      before_inf = @fund_user_history.before_change_action
      @fund_user_history.destroy
      before_inf[:account].plus(before_inf[:value])
    end
    redirect_to request.referer unless Rails.env.test?
  end

  private
    def select_fund_user
      @fund_user = FundUser.find(params[:fund_user_id])
    end

    def fund_user_historys_params
      params.require(:fund_user_history).permit(
        :date,
        :value,
        :commission,
        :buy_or_sell,
        :pay_date
      )
    end

    def association_model_update
      if params[:fund_user_history][:account_or_card] == "0"
        @fund_user_history.account_id = params[:fund_user_history][:account]
        @fund_user_history.card_id = nil
      elsif params[:fund_user_history][:account_or_card] == "1"
        @fund_user_history.card_id = params[:fund_user_history][:card]
        @fund_user_history.account_id = nil
      elsif params[:fund_user_history][:account_or_card] == "2"
        @fund_user_history.card_id = nil
        @fund_user_history.account_id = nil
      end
    end

    def correct_user!
      @fund_user_history = @fund_user.fund_user_histories.find(params[:id])
      redirect_to root_path unless current_user == @fund_user_history.fund_user.user
    end
  
end
