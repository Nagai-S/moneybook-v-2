class FundUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!, only: :destroy
  before_action :to_explanation, only: [:index, :new]
  before_action :set_previous_url, only: :new
  
  def index
    fund_users_not_order = current_user.fund_users
    @fund_users = fund_users_not_order.sort{|a, b| (-1) * (a.now_value <=> b.now_value)}
  end
  
  def new
    @fund = Fund.find(params[:fund_id])
    @fund_user = current_user.fund_users.build
  end
  
  def create
    @fund = Fund.find(params[:fund_user][:fund_id])
    @fund_user = current_user.fund_users.build(fund_user_params)
    total_buy_value = params[:fund_user][:total_buy_value]
    if @fund_user.save
      if total_buy_value.to_i != 0
        @fund_user.fund_user_histories.create(
          value: total_buy_value,
          date: Date.today,
          commission: 0,
          buy_or_sell: true,
          pon: true
        )
      end
      if @fund.update_on != Date.today
        @fund.set_now_value_of_fund
      end
      redirect_to fund_users_path
    else
      flash.now[:danger] = "投資信託の登録に失敗しました。"
      render 'new'
    end
  end

  def destroy
    @fund_user.destroy
    redirect_to request.referer unless Rails.env.test?
  end
  
  def update
    @fund_user = current_user.fund_users.find(params[:id])
    if @fund_user.update(
      average_buy_value: params[:fund_user][:average_buy_value]
    )
      render json: {status: "success"}
    else
      render json: {status: "error"}
    end
  end
  
  private
    def fund_user_params
      params.require(:fund_user).permit(:fund_id, :average_buy_value)
    end  

    def correct_user!
      @fund_user = FundUser.find(params[:id])
      redirect_to root_path unless @fund_user.user == current_user
    end
end
