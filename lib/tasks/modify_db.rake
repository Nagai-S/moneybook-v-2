namespace :modify_db do
  desc "テスト用初期データベースの細かい修正"
  task modify_event: :environment do
    Event.where(pon: false).where(pay_date: nil).each do |event|
      event.update(pon: true)
    end
  end
  task modify_ax: :environment do
    AccountExchange.where(pon: false).where(pay_date: nil).each do |ax|
      ax.update(pon: true)
    end
  end
end