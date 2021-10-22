module FundUserHistoriesHelper
  def active_is_buy_or_sell
    if @fund_user_history.buy_or_sell
      return {buy: "active", sell: ""}
    else
      return {buy: "", sell: "active"}
    end
  end

  def card_id_for_fund_user_history
    if @fund_user_history.card
      @fund_user_history.card.id
    elsif @fund_user.fund_user_histories.where.not(card_id: nil).exists?
      @fund_user
      .fund_user_histories
      .where.not(card_id: nil)
      .first.card.id if @fund_user
      .fund_user_histories.where.not(card_id: nil).exists?
    end
  end

  def account_id_for_fund_user_history(buy_or_sell)
    if @fund_user_history.account
      @fund_user_history.account.id
    else
      @fund_user
      .fund_user_histories.where.not(account_id: nil)
      .where(buy_or_sell: buy_or_sell)
      .first.account.id if @fund_user
      .fund_user_histories
      .where.not(account_id: nil).where(buy_or_sell: buy_or_sell).exists?
    end
  end

  def active_is_account_or_card_for_fund_user_history(buy_or_sell, edit_or_not)
    if !buy_or_sell
      return {account: "active", card: "", nothing: "", number: 0}
    elsif edit_or_not && !@fund_user_history.account && !@fund_user_history.card
      return {account: "", card: "", nothing: "active", number: 2}
    elsif @fund_user_history.card
      return {account: "", card: "active", number: 1}
    elsif @fund_user_history.account
      return {account: "active", card: "", nothing: "", number: 0}
    elsif @fund_user.fund_user_histories.exists?
      if @fund_user.fund_user_histories.where(buy_or_sell: true).first.card
        return {account: "", card: "active", number: 1}
      elsif @fund_user.fund_user_histories.where(buy_or_sell: true).first.account
        return {account: "active", card: "", nothing: "", number: 0}
      else
        {account: "active", card: "", nothing: "", number: 0}
      end
    else
      return {account: "active", card: "", nothing: "", number: 0}
    end
  end
end
