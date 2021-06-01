class Api::AuthController < Api::ApplicationController
  before_action :auth_user

  def daily_email
    aweek_later=Date.today.next_day(7)
    Card.all.each do |card|
      pay_date=MyFunction::FlexDate.return_date(
        aweek_later.year,
        aweek_later.month,
        card.pay_date
      )
      if aweek_later==pay_date
        CardMailer.with(
          user: card.user,
          card: card,
          pay_date: pay_date
        ).monthly_card_info.deliver_now
      end
    end
    render json: {message: "success"}, status: 200
  end
end