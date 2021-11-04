class Api::AccountExchangesController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    user = currentUser
    axs = user.account_exchanges
    render json: {axs: axs}
  end
  
  def create
    user = currentUser
    @ax = user.account_exchanges.build(ax_params)
    association_model_update

    if @ax.save
      @ax.after_change_action
      render json: {message: "success"}
    else
      render json: {message: "error", errors: @ax.errors}, status: 404
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
end