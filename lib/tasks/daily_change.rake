namespace :daily_change do
  desc "fundのvalueを更新する"
  task update_fund_value: :environment do
    FundUser.all.includes(:fund)
      .uniq { |fund_user| fund_user.fund_id }
      .each { |fund_user| fund_user.fund.set_now_value_of_fund }
  end
end
