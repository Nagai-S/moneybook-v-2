namespace :daily_change do
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
