class Api::FundUserHistoriesController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    fund_user = @user.fund_users.find(params[:fund_user_id])
    fund_user_histories = fund_user.fund_user_histories
    render json: { fund_user_histories: fund_user_histories }
  end
end
