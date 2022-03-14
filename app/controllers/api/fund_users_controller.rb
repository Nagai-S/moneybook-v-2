class Api::FundUsersController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    fund_users = @user.fund_users
    render json: { fund_users: fund_users }
  end
end
