module CardsHelper
  def account_id_for_card
    if @card.account
      @card.account.id
    elsif current_user.cards.exists?
      current_user.cards.first.account_id
    end
  end
end
