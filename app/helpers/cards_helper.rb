module CardsHelper
  def account_id_for_new
    @card.account.id if @card.account  
  end
end
