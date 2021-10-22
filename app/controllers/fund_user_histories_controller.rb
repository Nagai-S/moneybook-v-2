class FundUserHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :select_fund_user
  before_action :select_fund_user_history, only: [:destroy, :edit, :update]
  before_action :correct_user!, only: [:destroy, :edit, :update]
  before_action :to_explanation, only: [:index, :new]
  before_action :set_previous_url, only: [:new, :edit]
  
  def index
    @fund_user_histories = @fund_user.fund_user_histories
  end

  def new
    @fund_user_history = @fund_user.fund_user_histories.build
  end

  def create
    @fund_user_history = @fund_user.fund_user_histories.build(fund_user_histories_params)
    association_model_update

    if @fund_user_history.save
      @fund_user_history.after_change_action(@fund_user_history.pay_date)
      redirect_to_previou_url
    else
      flash.now[:danger] = @fund_user_history.buy_or_sell_name + "に失敗しました。"
      render "new"
    end
  end

  def destroy
    @fund_user_history.destroy
    redirect_to request.referer unless Rails.env.test?
  end

  def edit
  end

  def update
    association_model_update
    if @fund_user_history.update(fund_user_histories_params)
      @fund_user_history.after_change_action(@fund_user_history.pay_date)
      redirect_to_previou_url
    else
      flash.now[:danger] = "編集に失敗しました。"
      render "edit"
    end
  end

  private
    def select_fund_user
      @fund_user = FundUser.find(params[:fund_user_id])
    end

    def select_fund_user_history
      @fund_user_history = FundUserHistory.find(params[:id])
    end

    def fund_user_histories_params
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
      redirect_to root_path unless current_user == @fund_user_history.fund_user.user
    end
  
end
