module AccountsHelper
  def month_count
    if current_user.how_long_months_years[:months] < 5
      current_user.how_long_months_years[:months]
    else
      5
    end
  end

  def prev_month_event_date(i)
    current_user.events.first.date.prev_month(i)
  end

  def prev_year_event_date(i)
    current_user.events.first.date.prev_year(i)
  end

  def accounts_data_for_glaph
    assets_array = []
    @accounts.each do |account|
      assets_array.push([omit_string(account.name), account.now_value({scale: true}).round])
    end
    @fund_users.each do |fund_user|
      assets_array.push([omit_string(fund_user.fund.name), fund_user.now_value({scale: true}).round])
    end
    assets_array.sort { |a, b| (-1) * (a[1] <=> b[1]) }
  end
end
