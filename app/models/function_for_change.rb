module FunctionForChange
  def after_change_action(selected_pay_date)
    self.to_account.plus(self.value) if self.to_account
    
    if self.account
      self.update(pay_date: nil, pon: true)
      value=self.iae ? self.value : -self.value
      self.account.plus(value)
    elsif self.card
      if selected_pay_date
        pay_day=Date.new(selected_pay_date.year,selected_pay_date.month,self.card.pay_date)
      else
        pay_day=self.decide_pay_day
      end

      self.update(pay_date: pay_day)

      self.change_pon
    end
  end

  def change_pon
    if self.pay_date<=Date.today
      self.update(pon: true)
      self.card.account.plus(-self.value)
    else
      self.update(pon: false)
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

  def decide_pay_day
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
  
end