class FundUserHistoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :select_fund_user
  before_action :correct_user!, only: %i[destroy edit update]
  before_action :to_explanation, only: %i[index new]
  before_action :set_previous_url, only: %i[new edit]

  def index
    @fund_user_histories = @fund_user.fund_user_histories
  end

  def new
    @fund_user_history = @fund_user.fund_user_histories.build
  end

  def create
    @fund_user_history =
      @fund_user.fund_user_histories.build(fund_user_histories_params)
      
    if @fund_user_history.save
      @fund_user_history.after_change_action
      redirect_to_previou_url
    else
      flash.now[:danger] =
        @fund_user_history.buy_or_sell_name + 'に失敗しました。'
      render 'new'
    end
  end

  def destroy
    if @fund_user_history.destroy
      unless Rails.env.test?
        redirect_to request.referer
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] =
        'エラーが発生しました。ブラウザをリロードしてやり直してください'
      unless Rails.env.test?
        redirect_to request.referer
      else
        redirect_to root_path
      end
    end
  end

  def edit; end

  def update
    if @fund_user_history.update(fund_user_histories_params)
      @fund_user_history.after_change_action
      redirect_to_previou_url
    else
      flash.now[:danger] = '編集に失敗しました。'
      render 'edit'
    end
  end

  private

  def select_fund_user
    @fund_user = FundUser.find(params[:fund_user_id])
  end

  def fund_user_histories_params
    if params[:fund_user_history][:account_or_card] == '0'
      params[:fund_user_history][:card_id] = nil
    elsif params[:fund_user_history][:account_or_card] == '1'
      card = Card.find_by(id: params[:fund_user_history][:card_id])
      params[:fund_user_history][:account_id] = card.account_id
    elsif params[:fund_user_history][:account_or_card] == '2'
      params[:fund_user_history][:card_id] = nil
      params[:fund_user_history][:account_id] = nil
    end
    params
      .require(:fund_user_history)
      .permit(
        :date, 
        :value, 
        :commission, 
        :buy_or_sell, 
        :pay_date,
        :card_id,
        :account_id
      )
  end

  def correct_user!
    @fund_user_history = FundUserHistory.find(params[:id])
    unless current_user == @fund_user_history.fund_user.user
      redirect_to root_path
    end
  end
end
