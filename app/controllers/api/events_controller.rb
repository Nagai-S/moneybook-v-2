class Api::EventsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :currentUser

  def index
    user=currentUser
    events=user.events
    return json: {events: events}
  end
  
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
      @event.genre_id=params[:event][:genre]
      if params[:event][:account_or_card]=="0"
        @event.account_id=params[:event][:account]
        @event.card_id=nil
      elsif params[:event][:account_or_card]=="1"
        @event.card_id=params[:event][:card]
        @event.account_id=nil
      end
    end
end