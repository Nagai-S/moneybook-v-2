class Api::FundsController < Api::ApplicationController
  before_action :authenticate_user!

  def index
    funds = Fund.all
    render json: { funds: funds }
  end
end
