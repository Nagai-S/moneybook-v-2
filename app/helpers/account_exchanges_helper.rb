module AccountExchangesHelper
  def to_id_for_new_ax
    if @ax.to_account
      @ax.to_account.id
    elsif current_user.account_exchanges.exists?
      current_user.account_exchanges.first.to_account.id
    end
  end

  def card_id_for_ax
    if @ax.card
      @ax.card.id
    elsif current_user.account_exchanges.where.not(card_id: nil).exists?
      current_user.account_exchanges.where.not(card_id: nil).first.card.id
    end
  end

  def account_id_for_ax
    if @ax.account
      @ax.account.id
    elsif current_user.account_exchanges.where.not(source_id: nil).exists?
      current_user.account_exchanges.where.not(source_id: nil).first.account.id
    end
  end
  
  def active_is_account_or_card_for_ax
    if @ax.card
      return {account: "", card: "active", number: 1}
    elsif @ax.account
      return {account: "active", card: "", number: 0}
    elsif current_user.account_exchanges.exists?
      if current_user.account_exchanges.first.card
        return {account: "", card: "active", number: 1}
      elsif current_user.account_exchanges.first.account
        return {account: "active", card: "", number: 0}
      end
    else
      return {account: "active", card: "", number: 0}
    end
  end
  
end
