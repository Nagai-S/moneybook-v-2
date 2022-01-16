class FundsController < ApplicationController
  before_action :authenticate_user!

  def index
    all_funds = Fund.all
    @funds = all_funds.page(params[:page]).per(80)
    @result_num = all_funds.size
  end

  def search
    @name = params[:name]
    funds = Fund.all
    down_name = @name.downcase if @name
    funds_result =
      @name != '' ? funds.where('lower(name) LIKE ?', "%#{down_name}%") : funds
    @funds = funds_result.page(params[:page]).per(80)
    @result_num = funds_result.size
  end
end
