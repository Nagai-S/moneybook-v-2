namespace :daily_change do
  desc "引き落とし日をすぎていないか確認してすぎていたら変更する"
  task change_pon: :environment do
    Event.where(pon: false).each do |event|
      event.change_pon
    end
    AccountExchange.where(pon: false).each do |ax|
      ax.change_pon
    end
    FundUserHistory.where(pon: false).each do |fuh|
      fuh.change_pon
    end
  end

  desc "fundのvalueを更新する"
  task update_fund_value: :environment do
    used_funds = []
    FundUser.all.includes(:fund).each do |fund_user|
      used_funds.push(fund_user.fund)
    end
    used_funds.uniq.each do |fund|
      fund.set_now_value_of_fund
    end
  end
end
