module EventsHelper
  def genre_id_for_new_event
    @event.genre.id if @event.genre
  end

  def account_id_for_new_event
    @event.account.id if @event.account
  end

  def card_id_for_new_event
    @event.card.id if @event.card
  end

  def date_for_new_event
    @event.date ? @event.date : Date.today
  end

  def active_is_ex_or_in
    if @event.iae
      return {ex: "", in: "active"}
    else
      return {ex: "active", in: ""}
    end
  end

  def active_is_account_or_card
    if @event.card
      return {account: "", card: "active", number: 1}
    else
      return {account: "active", card: "", number: 0}
    end
  end

  def iae(event)
    event.iae ? "true" : "false"
  end

  def plus_minus(event)
    "-" unless event.iae
  end

  def account_or_card_name(event)
    if event.account
      event.account.name
    elsif event.card
      event.card.name
    end
  end
end
