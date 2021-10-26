module AccountsHelper
  def month_count
    current_user
    .how_long_months_years[:months] < 5 ? 
    current_user.how_long_months_years[:months] : 5
  end
  
  def prev_month_event_date(i)
    current_user.events.first.date.prev_month(i)
  end

  def prev_year_event_date(i)
    current_user.events.first.date.prev_year(i)
  end
  
  def each_value_for_year(date)
    income = current_user
    .events.where(date: date.all_year, iae: true).sum(:value)
    ex = current_user
    .events.where(date: date.all_year, iae: false).sum(:value)
    return {in: income, ex: ex, plus_minus: income-ex}
  end

  def accounts_data_for_glaph
    assets_array = []
    @accounts.each do |account|
      assets_array.push([omit_string(account.name), account.now_value])
    end
    @fund_users.each do |fund_user|
      assets_array.push([omit_string(fund_user.fund.name), fund_user.now_value])
    end
    assets_array.sort{|a, b| (-1) * (a[1] <=> b[1])}
  end

end
