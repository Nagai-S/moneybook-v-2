module AccountExchangesHelper
  def to_id_for_new_ax
    @ax.to_account.id if @ax.to_account
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
  
  
end
