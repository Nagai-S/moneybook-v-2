class Event < ApplicationRecord
  belongs_to :user
  belongs_to :card, optional: true
  belongs_to :genre, optional: true
  belongs_to :account, optional: true

  default_scope -> {order(date: :desc)}

  validates :date, presence: true
  validates :value, presence: {message: "は一桁以上入力してください。"},
  numericality: {
    message: "は半角数字で入力してください。", 
    only_integer: {message: "は整数で入力してください。"}
  }

  def after_change_action(selected_pay_date)
    if self.account
      self.update(pay_date: nil, pon: true)
      value=self.iae ? self.value : -self.value
      self.account.plus(value)
    elsif self.card
      if selected_pay_date
        pay_day=selected_pay_date
      else
        if self.card.pay_date > self.card.month_date
          if self.card.month_date < self.date.day
            a=self.date.next_month
            pay_day=Date.new(a.year, a.month, self.card.pay_date)
          else
            pay_day=Date.new(event_date.year, event_date.month, self.card.pay_date)
          end
        else
          if self.card.month_date < self.date.day
            a=self.date.next_month(2)
            pay_day=Date.new(a.year, a.month, self.card.pay_date)
          else
            a=self.date.next_month
            pay_day=Date.new(a.year, a.month, self.card.pay_date)
          end
        end
      end

      if pay_day<=Date.today
        self.update(pon: true)
        self.card.account.plus(-self.value)
      else
        self.update(pon: false)
      end

      self.update(pay_date: pay_day)
    end
  end

  def before_change_action
    if self.card==nil
      account=self.account
      value=self.iae ? -self.value : self.value
    else
      account=self.card.account
      value= self.pon ? self.value : 0
    end

    return {account: account, value: value}
  end
  
end
