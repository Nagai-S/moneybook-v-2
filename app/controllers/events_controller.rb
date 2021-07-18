class EventsController < ApplicationController
  include MyFunction::Search
  before_action :authenticate_user!
  before_action :select_event, only: [:destroy, :edit, :update]
  before_action :to_explanation, only: [:index, :new, :search]
  before_action :confirm_parents_deleted, only: [:destroy, :edit, :update]

  def index
    @events = current_user.events.includes(:account,:card,:genre).page(params[:page]).per(80)
  end

  def new
    @event = current_user.events.build
  end

  def search
    events = current_user.events
    events = search_iae(events)
    events = search_genre(events)
    events = search_account(events)
    events = search_card(events)
    events = search_memo(events)
    events = search_money(events)
    events = search_date(events)

    value_array = []
    events.each do |event|
      value_include_plus_minus = event.iae ? event.value : -event.value
      value_array << value_include_plus_minus
    end
    @sum = value_array.sum
    @events = events.includes(:account,:card,:genre).page(params[:page]).per(80)
  end

  def create
    @event = current_user.events.build(events_params)
    association_model_update

    if @event.save
      @event.after_change_action(@event.pay_date)
      redirect_to user_events_path(current_user)
    else
      flash.now[:danger] = "イベントの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    before_inf = @event.before_change_action
    @event.destroy
    before_inf[:account].plus(before_inf[:value])
    redirect_to request.referer unless Rails.env.test?
  end
  
  def edit
    session[:previous_url] = request.referer
  end

  def update
    before_inf = @event.before_change_action

    association_model_update
    if @event.update(events_params)
      before_inf[:account].plus(before_inf[:value])
      @event.after_change_action(@event.pay_date)
      unless Rails.env.test?
        redirect_to session[:previous_url]
        session[:previous_url].clear
      end
    else
      flash.now[:danger] = "イベントの編集に失敗しました。"
      render "edit"
    end
  end
  
  private
    def events_params
      params.require(:event).permit(:date, :value, :memo, :iae, :pay_date)
    end    

    def select_event
      @event = Event.find_by(user_id: params[:user_id], id: params[:id])
    end

    def confirm_parents_deleted
      redirect_to user_events_path(current_user) if @event.parents_deleted
    end

    def association_model_update
      @event.genre_id = params[:event][:genre]
      if params[:event][:account_or_card] == "0"
        @event.account_id = params[:event][:account]
        @event.card_id = nil
      elsif params[:event][:account_or_card] == "1"
        @event.card_id = params[:event][:card]
        @event.account_id = nil
      end
    end
end
    
