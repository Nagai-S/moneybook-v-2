class Api::AuthController < Api::ApplicationController
  before_action :auth_user

  def daily_email
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
    render json: {message: "success"}, status: 200
  end

  def update_fund_value
    used_funds = []
    FundUser.all.includes(:fund).each do |fund_user|
      used_funds.push(fund_user.fund)
    end
    used_funds.uniq.each do |fund|
      fund.set_now_value_of_fund
    end
    render json: {message: "success"}, status: 200
  end

  def regist_funds
    name = params[:fund][:name]
    value = params[:fund][:value]
    string_id = params[:fund][:string_id]
    Fund.create(
      name: name,
      value: value,
      string_id: string_id
    )
    render json: {message: "success"}, status: 200
  end
end