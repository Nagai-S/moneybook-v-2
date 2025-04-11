namespace :monthly_mail do
  desc "クレジットカードの引き落とし日の1週間前に利用額をメールする"
  task send_card_mail: :environment do
    aweek_later = Time.current.to_date.next_day(7)
    Card.includes(:events).each do |card|
      pay_date = MyFunction::FlexDate.new(
        aweek_later.year,
        aweek_later.month,
        card.pay_date
      )
      if card.events.where(pay_date: pay_date).empty?
        next
      end
      if aweek_later == pay_date
        CardMailer.with(
          user: card.user,
          card: card,
          pay_date: pay_date
        ).monthly_card_info.deliver_now
      end
    end
  end
end
