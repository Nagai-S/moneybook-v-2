class EventsController < ApplicationController
  include MyFunction::Search
  before_action :authenticate_user!
  before_action :correct_user!, only: %i[destroy edit update]
  before_action :to_explanation, only: %i[index new search]
  before_action :set_previous_url, only: %i[new edit]

  def index
    @events =
      current_user
        .events
        .includes(:account, :card, :genre)
        .page(params[:event_page])
        .per(50)
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
    @events =
      events.includes(:account, :card, :genre).page(params[:event_page]).per(80)
  end

  def create
    @event = current_user.events.build(events_params)
    if @event.save
      redirect_to_previou_url
    else
      flash.now[:danger] = 'イベントの作成に失敗しました。'
      render 'new'
    end
  end

  def destroy
    @event.destroy
    redirect_to_referer
  end

  def edit; end

  def update
    if @event.update(events_params)
      redirect_to_previou_url
    else
      flash.now[:danger] = 'イベントの編集に失敗しました。'
      render 'edit'
    end
  end

  private

  def events_params
    if params[:event][:account_or_card] == '0'
      params[:event][:card_id] = nil
    elsif params[:event][:account_or_card] == '1'
      card = Card.find_by(id: params[:event][:card_id])
      params[:event][:account_id] = card.account_id
    end
    params.require(:event).permit(
      :date, 
      :value, 
      :memo, 
      :iae, 
      :pay_date, 
      :genre_id, 
      :account_id, 
      :card_id
    )
  end

  def correct_user!
    @event = Event.find_by(id: params[:id])
    redirect_to root_path unless current_user == @event.user
  end
end
