namespace :monthly_mail do
  desc "クレジットカードの引き落とし日の1週間前に利用額をメールする"
  task send_card_mail: :environment do
    aweek_later = Date.today.next_day(7)
    Card.all.each do |card|
      pay_date = MyFunction::FlexDate.return_date(
        aweek_later.year,
        aweek_later.month,
        card.pay_date
      )
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
