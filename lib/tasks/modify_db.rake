require 'nkf'
namespace :modify_db do
  desc "fundsの半角全角を揃える + 改行コードを消す"
  task modify_funds: :environment do
    Fund.all.each do |fund|
      name1 = NKF.nkf('-w -Z4', fund.name)
      name2 = NKF.nkf('-w -X', name1)
      string_id = fund.string_id
      fund.update(name: name2.delete("\n"), string_id: string_id.delete("\n"))
    end
  end

  desc "modify positive and negative in events-value"
  task modify_value_of_events: :environment do
    Event.all.each do |event|
      if !event.iae
        event.update(value: -event.value)
      end
    end
  end
end