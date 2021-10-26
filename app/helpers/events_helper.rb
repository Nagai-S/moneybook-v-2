module EventsHelper
  def genre_id_for_event(iae)
    if @event.genre
      @event.genre.id
    else
      current_user
      .events
      .where.not(genre_id: nil)
      .where(iae: iae).first.genre.id if current_user
      .events.where.not(genre_id: nil).where(iae: iae).exists?
    end
  end

  def card_id_for_event
    if @event.card
      @event.card.id
    elsif current_user.events.where.not(card_id: nil).exists?
      current_user
      .events
      .where.not(card_id: nil)
      .first.card.id if current_user
      .events.where.not(card_id: nil).exists?
    end
  end

  def account_id_for_event(iae)
    if @event.account
      @event.account.id
    else
      current_user
      .events.where.not(account_id: nil)
      .where(iae: iae)
      .first.account.id if current_user
      .events.where.not(account_id: nil).where(iae: iae).exists?
    end
  end
  
  def active_is_account_or_card_for_event(iae)
    if iae
      return {account: "active", card: "", number: 0}
    elsif @event.card
      return {account: "", card: "active", number: 1}
    elsif @event.account
      return {account: "active", card: "", number: 0}
    elsif current_user.events.exists?
      if current_user.events.where(iae: false).first.card
        return {account: "", card: "active", number: 1}
      elsif current_user.events.where(iae: false).first.account
        return {account: "active", card: "", number: 0}
      else
        {account: "active", card: "", number: 0}
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

  def this_month_data
    ex_genres = []
    current_user.genres.each do |genre|
      value = genre.events.where(
        iae: false,
        date: Date.today.all_month
      ).sum(:value)
      ex_genres.push([omit_string(genre.name), value]) if value > 0
    end
    ex_genres = ex_genres.sort{|a, b| (-1) * (a[1] <=> b[1])}
    in_genres = []
    current_user.genres.each do |genre|
      value = genre.events.where(iae: true, date: Date.today.all_month).sum(:value)
      in_genres.push([omit_string(genre.name), value]) if value > 0
    end
    in_genres = in_genres.sort{|a, b| (-1) * (a[1] <=> b[1])}
    {
      ex_genres: ex_genres,
      in_genres: in_genres
    }
  end

end
