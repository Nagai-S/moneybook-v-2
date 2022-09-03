# お金の変化と引き落とし日を追うアルゴリズム
module MyFunction
  module FunctionForChange
    def after_change_action
      if card
        pay_day = pay_date ? MyFunction::FlexDate.new(
          pay_date.year,
          pay_date.month,
          card.pay_date
        ) : decide_pay_day
        update_columns(pay_date: pay_day)
      else
        update_columns(pay_date: nil)
      end
    end

    def payed?
      if pay_date
        return pay_date <= Date.today
      else
        return true
      end
    end    

    def decide_pay_day
      if card.pay_date > card.month_date
        if card.month_date < date.day
          a = date.next_month
          pay_day =
            MyFunction::FlexDate.new(a.year, a.month, card.pay_date)
        else
          pay_day =
            MyFunction::FlexDate.new(
              date.year,
              date.month,
              card.pay_date
            )
        end
      else
        if card.month_date < date.day
          a = date.next_month(2)
          pay_day =
            MyFunction::FlexDate.new(a.year, a.month, card.pay_date)
        else
          a = date.next_month
          pay_day =
            MyFunction::FlexDate.new(a.year, a.month, card.pay_date)
        end
      end
      return pay_day
    end
  end
end
