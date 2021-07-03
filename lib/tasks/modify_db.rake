namespace :modify_db do
  desc "データベースの細かい修正"
  task modif_event: :environment do
    Event.where(pon: false).where(pay_date: nil).each do |event|
      event.update(pon: true)
    end
  end
end