module CardsHelper
  def prev_pay_date(i)
    event_date=@card.events.where(pon: false).first.pay_date if @card.events.where(pon: false).first
    ax_date=@card.account_exchanges.where(pon: false).first.pay_date if @card.account_exchanges.where(pon: false).first

    if event_date && ax_date
      first_date= event_date>ax_date ? event_date : ax_date
    elsif event_date
      first_date=event_date
    elsif ax_date
      first_date=ax_date
    end

    return first_date.prev_month(i)
  end

  def account_id_for_card
    if @card.account
      @card.account.id
    elsif current_user.cards.exists?
      current_user.cards.first.account.id
    end
  end
  
end
