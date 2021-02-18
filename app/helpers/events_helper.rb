module EventsHelper
  def genre_id_for_new_event
    if @event.genre
      @event.genre.id
    elsif current_user.events.exists?
      current_user.events.first.genre.id
    end
  end

  def card_id_for_event
    if @event.card
      @event.card.id
    elsif current_user.events.where.not(card_id: nil).exists?
      current_user.events.where.not(card_id: nil).first.card.id
    end
  end

  def account_id_for_event
    if @event.account
      @event.account.id
    elsif current_user.events.where.not(account_id: nil).exists?
      current_user.events.where.not(account_id: nil).first.account.id
    end
  end
  

  def active_is_ex_or_in
    if @event.iae
      return {ex: "", in: "active"}
    else
      return {ex: "active", in: ""}
    end
  end

  def iae(event)
    event.iae ? "true" : "false"
  end

  def plus_minus(event)
    "-" unless event.iae
  end

end
