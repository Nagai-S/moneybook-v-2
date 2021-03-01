module EventsHelper
  def genre_id_for_event(iae)
    if @event.genre
      @event.genre.id
    else
      current_user.events.where(iae: iae).first.genre.id if current_user.events.where(iae: iae).exists?
    end
  end

  def card_id_for_event
    if @event.card
      @event.card.id
    elsif current_user.events.where.not(card_id: nil).exists?
      current_user.events.where.not(card_id: nil).first.card.id
    end
  end

  def account_id_for_event(iae)
    if @event.account
      @event.account.id
    else
      current_user.events.where.not(account_id: nil).where(iae: iae).first.account.id if current_user.events.where.not(account_id: nil).where(iae: iae).exists?
    end
  end
  
  def active_is_account_or_card_for_event(iae)
    if iae
      return {account: "active", card: "", number: 0}
    elsif current_user.events.exists?
      if current_user.events.first.card
        return {account: "", card: "active", number: 1}
      elsif current_user.events.first.account
        return {account: "active", card: "", number: 0}
      end
    else
      return {account: "active", card: "", number: 0}
    end
  end

  def active_is_ex_or_in
    if @event.iae
      return {ex: "", in: "active"}
    else
      return {ex: "active", in: ""}
    end
  end

  def which_iae(event)
    event.iae ? "true" : "false"
  end

  def plus_minus(event)
    "-" unless event.iae
  end

end
