module CardsHelper
  def account_id_for_new_card
    @card.account.id if @card.account  
  end
end
