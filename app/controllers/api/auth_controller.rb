class Api::AuthController < Api::ApplicationController
  include ApplicationHelper
  before_action :auth_user

  def daily_email
    aweek_later = Time.current.to_date.next_day(7)
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
    data_params = []
    params[:funds].each do |data|
      fund = {
        id: data[:fund][:id],
        name: data[:fund][:name],
        value: data[:fund][:value],
        string_id: data[:fund][:string_id],
      }
      data_params.push fund
    end
    Fund.create(data_params)
    render json: { message: 'All funds are created' }, status: 200
  end

  def initial_register_db    
    if params['kind'] == '0' # create events
      data_params = []
      params['data_array'].each do |data|
        event = {
          date:
            Date.new(
              data['date(1i)'].to_i,
              data['date(2i)'].to_i,
              data['date(3i)'].to_i
            ),
          iae: data[:iae],
          memo: data[:memo],
          value: data[:value],
          account_id: data[:account_id],
          card_id: data[:card_id],
          genre_id: data[:genre_id],
        }
        if data['pay_date(1i)']
          event[:pay_date] = Date.new(
            data['pay_date(1i)'].to_i,
            data['pay_date(2i)'].to_i,
            data['pay_date(3i)'].to_i
          )
        end
        data_params.push event
      end
      User.first.events.create(data_params)
      render json: { message: 'All events are created' }
    elsif params['kind'] == '1' # create account exchange
      data_params = []
      params['data_array'].each do |data|
        ax = {
          date:
            Date.new(
              data['date(1i)'].to_i,
              data['date(2i)'].to_i,
              data['date(3i)'].to_i
            ),
          value: data[:value],
          source_id: data[:source_id],
          card_id: data[:card_id],
          to_id: data[:to_id],
        }
        if data['pay_date(1i)']
          ax[:pay_date] = Date.new(
            data['pay_date(1i)'].to_i,
            data['pay_date(2i)'].to_i,
            data['pay_date(3i)'].to_i
          )
        end
        data_params.push ax
      end
      User.first.account_exchanges.create(data_params)
      render json: { message: 'All account exchanges are created' }
    elsif params['kind'] == '2' # create fund_user history
      fund_user =
        User.first.fund_users.create(
          fund_id: params['fund_id'],
          average_buy_value: params['average_buy_value']
        )
      data_params = []
      params['fuh'].each do |fuh|
        new_fuh = {
          date:
            Date.new(
              fuh['date(1i)'].to_i,
              fuh['date(2i)'].to_i,
              fuh['date(3i)'].to_i
            ),
          buy_or_sell: fuh['buy_or_sell'],
          commission: fuh['commission'],
          value: fuh['value'],
          account_id: fuh['account_id'],
          card_id: fuh['card_id'],
          buy_date: Date.new(
            fuh['buy_date(1i)'].to_i,
            fuh['buy_date(2i)'].to_i,
            fuh['buy_date(3i)'].to_i
          ),
        }
        if fuh['pay_date(1i)']
          new_fuh[:pay_date] = Date.new(
            fuh['pay_date(1i)'].to_i,
            fuh['pay_date(2i)'].to_i,
            fuh['pay_date(3i)'].to_i
          )          
        end
        data_params.push new_fuh
      end
      fund_user.fund_user_histories.create(data_params)
      render json: { message: 'All fund_user_histories are created' }
    end
  end
end
