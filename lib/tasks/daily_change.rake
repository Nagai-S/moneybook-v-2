namespace :daily_change do
  desc "引き落とし日をすぎていないか確認してすぎていたら変更する"
  task change_pon: :environment do
    Event.where(pon: false).each do |event|
      event.change_pon(false)
    end
    AccountExchange.where(pon: false).each do |event|
      event.change_pon(false)
    end
  end
end
