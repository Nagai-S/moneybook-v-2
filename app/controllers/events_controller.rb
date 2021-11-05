class EventsController < ApplicationController
  include MyFunction::Search
  before_action :authenticate_user!
  before_action :select_event, only: [:destroy, :edit, :update]
  before_action :correct_user!, only: [:destroy, :edit, :update]
  before_action :to_explanation, only: [:index, :new, :search]
  before_action :set_previous_url, only: [:new, :edit]

  def index
    @events = current_user
    .events
    .includes(:account,:card,:genre)
    .page(params[:page]).per(50)
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
    @events = events
    .includes(:account,:card,:genre)
    .page(params[:page]).per(80)
  end

  def create
    @event = current_user.events.build(events_params)
    association_model_update

    if @event.save
      @event.after_change_action
      redirect_to_previou_url
    else
      flash.now[:danger] = "イベントの作成に失敗しました。"
      render "new"
    end
  end
  
  def destroy
    if @event.destroy
      unless Rails.env.test?
        redirect_to request.referer 
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = "エラーが発生しました。ブラウザをリロードしてやり直してください"
      unless Rails.env.test?
        redirect_to request.referer 
      else
        redirect_to root_path
      end
    end
  end
  
  def edit
  end

  def update
    association_model_update
    if @event.update(events_params)
      @event.after_change_action
      redirect_to_previou_url
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
      @event = Event.find_by(id: params[:id])
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

    def correct_user!
      redirect_to root_path unless current_user == @event.user
    end
end
    
