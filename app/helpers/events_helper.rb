module EventsHelper
  def genre_id_for_event(iae)
    if @event.genre
      @event.genre.id
    else
      if current_user.events.where.not(genre_id: nil).where(iae: iae).exists?
        current_user
          .events
          .where.not(genre_id: nil)
          .where(iae: iae)
          .first
          .genre_id
      end
    end
  end

  def selected_card_for_event
    if @event.card
      @event.card
    elsif current_user.events.where.not(card_id: nil).exists?
      if current_user.events.where.not(card_id: nil).exists?
        current_user.events.where.not(card_id: nil).first.card
      end
    end
  end

  def selected_account_for_event(iae)
    if @event.account
      @event.account
    else
      if current_user.events.where.not(account_id: nil).where(iae: iae).exists?
        current_user
          .events
          .where.not(account_id: nil)
          .where(iae: iae)
          .first
          .account
      end
    end
  end

  def currency_id_for_event(iae)
    if @event.currency_id
      @event.currency_id
    else
      if current_user.events.where.not(account_id: nil).where(iae: iae).exists?
        current_user.events.where.not(account_id: nil).where(iae: iae).first.currency_id
      end
    end
  end

  def active_is_account_or_card_for_event(iae)
    if iae
      return { account: 'active', card: '', number: 0 }
    elsif @event.card
      return { account: '', card: 'active', number: 1 }
    elsif @event.account
      return { account: 'active', card: '', number: 0 }
    elsif current_user.events.exists?
      if current_user.events.where(iae: false).first &&
           current_user.events.where(iae: false).first.card
        return { account: '', card: 'active', number: 1 }
      elsif current_user.events.where(iae: false).first &&
            current_user.events.where(iae: false).first.account
        return { account: 'active', card: '', number: 0 }
      else
        { account: 'active', card: '', number: 0 }
      end
    else
      return { account: 'active', card: '', number: 0 }
    end
  end

  def active_is_ex_or_in
    if @event.iae
      return { ex: '', in: 'active' }
    else
      return { ex: 'active', in: '' }
    end
  end

  def which_iae(event)
    event.iae ? 'true' : 'false'
  end

  def this_month_data_for_glaph
    ex_genres = []
    current_user.genres.where(iae: false).each do |genre|
      events_for_genre = genre.events.where(date: today(current_user).all_month)
      value = current_user.calculate_in_ex_for_events(events_for_genre)[:ex]
      ex_genres.push([omit_string(genre.name), -value.round]) if value.abs > 0
    end
    ex_genres = ex_genres.sort { |a, b| (-1) * (a[1] <=> b[1]) }
    in_genres = []
    current_user.genres.where(iae: true).each do |genre|
      events_for_genre = genre.events.where(date: today(current_user).all_month)
      value = current_user.calculate_in_ex_for_events(events_for_genre)[:in]
      in_genres.push([omit_string(genre.name), value.round]) if value.abs > 0
    end
    in_genres = in_genres.sort { |a, b| (-1) * (a[1] <=> b[1]) }
    { ex_genres: ex_genres, in_genres: in_genres }
  end
end
