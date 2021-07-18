class FundsController < ApplicationController
  def index
    all_funds = Fund.all
    @funds = all_funds.page(params[:page]).per(80)
    @result_num = all_funds.size
  end

  def search
    @name = params[:name]
    funds = Fund.all
    funds_result = @name != "" ? funds.where('name LIKE ?', "%#{@name}%") : funds
    @funds = funds_result.page(params[:page]).per(80)
    @result_num = funds_result.size
  end
end
