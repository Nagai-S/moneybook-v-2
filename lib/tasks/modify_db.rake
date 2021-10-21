require 'nkf'
namespace :modify_db do
  desc "テスト用初期データベースの細かい修正"
  task modify_init_db: :environment do
    Event.where(pon: false).where(pay_date: nil).each do |event|
      event.update(pon: true)
    end
    AccountExchange.where(pon: false).where(pay_date: nil).each do |ax|
      ax.update(pon: true)
    end
  end

  desc "fundsの半角全角を揃える + 改行コードを消す"
  task modify_funds: :environment do
    Fund.all.each do |fund|
      name1 = NKF.nkf('-w -Z4', fund.name)
      name2 = NKF.nkf('-w -X', name1)
      string_id = fund.string_id
      fund.update(name: name2.delete("\n"), string_id: string_id.delete("\n"))
    end
  end
end