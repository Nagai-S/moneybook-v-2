namespace :daily_change_pon do
  desc "引き落とし日をすぎていないか確認してすぎていたら変更する"
  task check_pay_date: :environment do
    Event.where(pon: false).includes(:card, :account).each do |event|
      event.change_pon(false)
    end
    AccountExchange.where(pon: false).includes(:card, :account).each do |event|
      event.change_pon(false)
    end
  end
end
