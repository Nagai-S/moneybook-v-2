class Api::EventsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def create
    user=currentUser
    @event=user.events.build(events_params)
    association_model_update

    if @event.save
      @event.after_change_action(@event.pay_date)
      render json: {message: "success"}
    else
      render json: {messate: "error", errors: @event.errors}, status: 404
    end    
  end
  
  private
    def events_params
      params.require(:event).permit(:date, :value, :memo, :iae, :pay_date)
    end    

    def association_model_update
      @event.update(genre_id: params[:event][:genre])
      if params[:event][:account_or_card]=="0"
        @event.update(account_id: params[:event][:account], card_id: nil)
      elsif params[:event][:account_or_card]=="1"
        @event.update(card_id: params[:event][:card], account_id: nil)
      end
    end
end