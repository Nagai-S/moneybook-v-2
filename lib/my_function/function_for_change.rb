# お金の変化と引き落とし日を追うアルゴリズム  
module MyFunction
  module FunctionForChange
    def after_change_action(selected_pay_date)
      to_account.plus(value) if to_account
      
      if account
        update(pay_date: nil, pon: true)
        set_value = iae ? value : -value
        account.plus(set_value)
      elsif card
        if selected_pay_date
          pay_day = MyFunction::FlexDate.return_date(
            selected_pay_date.year,
            selected_pay_date.month,
            card.pay_date
          )
        else
          pay_day = decide_pay_day
        end
  
        update(pay_date: pay_day)
  
        change_pon(false)
      end
    end
  
    def change_pon(event_pon) #event_ponには変化前のaxやeventのponを入れる
      if pay_date <= Date.today && !event_pon
        card.account.plus(-value)
      elsif pay_date>Date.today && event_pon
        card.account.plus(value)
      end
      pay_date <= Date.today ? update(pon: true) : update(pon: false)
    end
  
    def before_change_action
      if card == nil
        set_account = account
        set_value = iae ? -value : value
      else
        set_account = card.account
        set_value = pon ? value : 0
      end
  
      return {account: set_account, value: set_value}
    end
  
    def decide_pay_day
      if card.pay_date > card.month_date
        if card.month_date < date.day
          a = date.next_month
          pay_day = MyFunction::FlexDate.return_date(a.year, a.month, card.pay_date)
        else
          pay_day = MyFunction::FlexDate.return_date(date.year, date.month, card.pay_date)
        end
      else
        if card.month_date < date.day
          a = date.next_month(2)
          pay_day = MyFunction::FlexDate.return_date(a.year, a.month, card.pay_date)
        else
          a = date.next_month
          pay_day = MyFunction::FlexDate.return_date(a.year, a.month, card.pay_date)
        end
      end
      return pay_day
    end

    def account_deleted
      account_nil = account == nil
      card_nil = card == nil
      if card_nil && account_nil
        return true
      else
        return false
      end
    end
    
  end
end