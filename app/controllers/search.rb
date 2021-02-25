# イベントの検索アルゴリズムをまとめたファイル
module Search
  def search_iae(events)
    @iae=params[:iae]
    return @iae=="0" ? events : events.where(iae: @iae)
  end
  
  def search_genre(events)
    @genre=params[:genre]
    return @genre=="" ? events : events.where(genre_id: @genre)
  end
  
  def search_account(events)
    @account=params[:account]
    return @account=="" ? events : events.where(account_id: @account)
  end
  
  def search_memo(events)
    @memo=params[:memo]
    return @memo=="" ? events : events.where('memo LIKE ?', "%#{@memo}%")
  end
  
  def search_money(events)
    @money_or_not=params[:money_or_not]
    @small_value=params[:money1]
    @large_value=params[:money2]
    @css_money= @money_or_not=="0" ? "none" : "block"
    return @money_or_not=="0" ? events : events.where(
      'value >= ? and value <= ?', @small_value.to_i, @large_value.to_i
    )
  end
  
  def search_date(events)
    @date_or_not=params[:date_or_not]
    @early_date=modify_date(params["date1(1i)"].to_i, params["date1(2i)"].to_i, params["date1(3i)"].to_i)
    @late_date=modify_date(params["date2(1i)"].to_i, params["date2(2i)"].to_i, params["date2(3i)"].to_i)
    @css_date= @date_or_not=="0" ? "none" : "block"
    return @date_or_not=="0" ? events : events.where(
      'date >= ? and date <= ?', @early_date, @late_date
    )
  end
  
  private
    # 日付の修正
    def modify_date(year, month, day)
      if (month==4 || month==6 || month==9 || month==11) && day==31
        new_day=30
      elsif month==2 && (day> 28)
        new_day=28
      else
        new_day=day
      end
      return Date.new(year, month, new_day)
    end
end




