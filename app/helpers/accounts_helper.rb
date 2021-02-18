module AccountsHelper
  def month_count
    current_user.how_long_months_years[:months]<5 ? current_user.how_long_months_years[:months] : 5
  end
  
  def prev_month_event_date(i)
    current_user.events.first.date.prev_month(i)
  end

  def prev_year_event_date(i)
    current_user.events.first.date.prev_year(i)
  end
  
  def each_value_for_month(date)
    income=current_user.events.where(date: date.all_month, iae: true).sum(:value)
    ex=current_user.events.where(date: date.all_month, iae: false).sum(:value)
    return {in: income, ex: ex, plus_minus: income-ex}
  end

  def each_value_for_year(date)
    income=current_user.events.where(date: date.all_year, iae: true).sum(:value)
    ex=current_user.events.where(date: date.all_year, iae: false).sum(:value)
    return {in: income, ex: ex, plus_minus: income-ex}
  end
  
end
