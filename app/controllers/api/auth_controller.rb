class Api::AuthController < Api::ApplicationController
  before_action :auth_user

  def daily_email
    aweek_later = Date.today.next_day(7)
    Card.all.each do |card|
      pay_date =
        MyFunction::FlexDate.new(
          aweek_later.year,
          aweek_later.month,
          card.pay_date
        )
      if aweek_later == pay_date
        CardMailer
          .with(user: card.user, card: card, pay_date: pay_date)
          .monthly_card_info
          .deliver_now
      end
    end
    render json: { message: 'success' }, status: 200
  end

  def update_fund_value
    used_funds = []
    FundUser
      .all
      .includes(:fund)
      .each { |fund_user| used_funds.push(fund_user.fund) }
    used_funds.uniq.each { |fund| fund.set_now_value_of_fund }
    render json: { message: 'success' }, status: 200
  end

  def register_funds
    id = params[:fund][:id]
    name = params[:fund][:name]
    value = params[:fund][:value]
    string_id = params[:fund][:string_id]
    Fund.create(id: id, name: name, value: value, string_id: string_id)
    render json: { message: name + 'is created' }, status: 200
  end

  def initial_register_db
    if params['kind'] == '0'
      event =
        User.first.events.create(
          date:
            Date.new(
              params['date(1i)'].to_i,
              params['date(2i)'].to_i,
              params['date(3i)'].to_i
            ),
          iae: params[:iae],
          memo: params[:memo],
          value: params[:value],
          account_id: params[:account_id],
          card_id: params[:card_id],
          genre_id: params[:genre_id],
          pon: params[:pon]
        )
      if params['pay_date(1i)']
        event.update(
          pay_date:
            Date.new(
              params['pay_date(1i)'].to_i,
              params['pay_date(2i)'].to_i,
              params['pay_date(3i)'].to_i
            )
        )
      end
      render json: { message: 'an event is created' }
    elsif params['kind'] == '1'
      ax =
        User.first.account_exchanges.create(
          date:
            Date.new(
              params['date(1i)'].to_i,
              params['date(2i)'].to_i,
              params['date(3i)'].to_i
            ),
          value: params[:value],
          source_id: params[:source_id],
          card_id: params[:card_id],
          to_id: params[:to_id],
          pon: params[:pon]
        )
      if params['pay_date(1i)']
        ax.update(
          pay_date:
            Date.new(
              params['pay_date(1i)'].to_i,
              params['pay_date(2i)'].to_i,
              params['pay_date(3i)'].to_i
            )
        )
      end
      render json: { message: 'an ax is created' }
    elsif params['kind'] == '2'
      fund_user =
        User.first.fund_users.create(
          fund_id: params['fund_id'],
          average_buy_value: params['average_buy_value']
        )
      params['fuh'].each do |fuh|
        new_fuh =
          fund_user.fund_user_histories.create(
            date:
              Date.new(
                fuh['date(1i)'].to_i,
                fuh['date(2i)'].to_i,
                fuh['date(3i)'].to_i
              ),
            buy_or_sell: fuh['buy_or_sell'],
            commission: fuh['commission'],
            value: fuh['value'],
            pon: fuh['pon'],
            account_id: fuh['account_id'],
            card_id: fuh['card_id']
          )
        if fuh['pay_date(1i)']
          new_fuh.update(
            pay_date:
              Date.new(
                fuh['pay_date(1i)'].to_i,
                fuh['pay_date(2i)'].to_i,
                fuh['pay_date(3i)'].to_i
              )
          )
        end
      end
      render json: { message: 'a fund_user with all fuhs is created' }
    end
  end
end
