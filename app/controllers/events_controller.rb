class EventsController < ApplicationController
  require "search"
  include Search
  before_action :authenticate_user!
  before_action :select_event, only: [:destroy, :edit, :update]
  before_action :to_explanation, only: [:index, :new]

  def index
    @events=current_user.events.page(params[:page]).per(80)
  end

  def new
    @event=current_user.events.build
  end

  def search
    events=current_user.events
    events=search_iae(events)
    events=search_genre(events)
    events=search_account(events)
    events=search_card(events)
    events=search_memo(events)
    events=search_money(events)
    events=search_date(events)

    @events=events.page(params[:page])
  end

  def create
    @event=current_user.events.build(events_params)
    association_model_update

    if @event.save
      @event.after_change_action(@event.pay_date)
      redirect_to user_events_path(current_user)
    else
      flash.now[:danger]="イベントの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    before_inf=@event.before_change_action
    @event.destroy
    before_inf[:account].plus(before_inf[:value])
    redirect_to user_events_path(current_user)
  end
  
  def edit
  end

  def update
    before_inf=@event.before_change_action

    association_model_update
    if @event.update(events_params)
      before_inf[:account].plus(before_inf[:value])
      @event.after_change_action(@event.pay_date)
      redirect_to user_events_path(current_user)
    else
      flash.now[:danger]="イベントの作成に失敗しました。"
      render "new"
    end
  end
  
  private
    def events_params
      params.require(:event).permit(:date, :value, :memo, :iae, :pay_date)
    end    

    def select_event
      @event=Event.find_by(:user_id => params[:user_id], :id => params[:id])
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
    
