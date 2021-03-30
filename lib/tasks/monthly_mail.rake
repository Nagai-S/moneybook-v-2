namespace :monthly_mail do
  desc "クレジットカードの引き落とし日の1週間前に利用額をメールする"
  task send_card_mail: :environment do
    aweek_later=Date.today.next_day(7)
    User.all.includes(:cards).each do |user|
      user.cards.each do |card|
        if aweek_later.day==card.pay_date
          CardMailer.with(
            user: user,
            card: card,
            pay_date: FlexDate.return_date(
              aweek_later.year,
              aweek_later.month,
              card.pay_date
            )
          ).monthly_card_info.deliver_now
        end
      end
    end
  end
end
